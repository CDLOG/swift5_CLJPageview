//
//  CLJPageView_content.swift
//  swift_pageview
//
//  Created by 陈乐杰 on 2022/2/7.
//

import UIKit

private let KContentCellID = "KContentCellID"


protocol CLJPageView_contentDelegate:AnyObject{
    func contentScroll(_ content:CLJPageView_content,target:Int)
    func contentScroll(_ content:CLJPageView_content,target:Int,progress:CGFloat)
}

class CLJPageView_content: UIView {

    weak var delegate:CLJPageView_contentDelegate?
    fileprivate var childsVc:[UIViewController]
    fileprivate var parents:UIViewController
    
    //按下时的偏移量
    fileprivate var startOffset:CGFloat = 0
    //点击顶部滚动时,禁止实现滚动代理
    fileprivate var isForbidScroll:Bool = false
    fileprivate lazy var collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collevtion = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        //开启分页
        collevtion.isPagingEnabled = true
        //去除弹簧效果
        collevtion.bounces = false
        //不滚动到顶部
        collevtion.scrollsToTop = false
        //隐藏滚动条
        collevtion.showsHorizontalScrollIndicator = false
        collevtion.dataSource = self
        collevtion.register(UICollectionViewCell.self, forCellWithReuseIdentifier: KContentCellID)
        collevtion.delegate = self
        return collevtion
        
    }()
    
    
    init(frame: CGRect,childsVc:[UIViewController],parents:UIViewController) {
        self.childsVc = childsVc
        self.parents = parents
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension CLJPageView_content{
    fileprivate func setupUI(){
        
        //将所有的子控制器添加到付控制器中
        for cvc in childsVc {
            parents.addChild(cvc)
        }
        //添加collectionview用于展示内容
        addSubview(collectionView)
    }
}
  
extension CLJPageView_content:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(childsVc.count)
        return childsVc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KContentCellID, for: indexPath)
        
        //先移除之前控制器的view
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        //添加控制器的view
        let childsV = childsVc[indexPath.item]
        childsV.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childsV.view)
//        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    
}

// MARK: - 代理CLJPageView_titleDelete
extension CLJPageView_content:CLJPageView_titleDelete{
    func titlesView(_ titlesView: CLJPageView_title, selectIndex: Int) {
        //滚动到匹配位置,通过顶部title滚动时,不执行collectionview的滚动代理,否则有互相代理的bug
        isForbidScroll = true
        let indexpath = IndexPath(item: selectIndex, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .left, animated: false)
    }
}
// MARK: - 代理UICollectionViewDelegate
extension CLJPageView_content:UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    /// 停止滚动时执行的方法
    private func contentEndScroll(){
//        判断当前是否是禁止状态
        guard !isForbidScroll else {return }
        
        
//        1.获取滚动到的位置
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
//        2,代理通知更新title
        delegate?.contentScroll(self, target: index)
    }
    
    
    
    //逐渐拖动
    //将要拖动content
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //拖动时解除禁止拖动 
        isForbidScroll = false
        startOffset = scrollView.contentOffset.x
    }
    //实时监听拖动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0.判断后开始的偏移量是否一致
        guard startOffset != scrollView.contentOffset.x,!isForbidScroll else {
            return
        }
        
        //1.定义targetIndex/progress
        var targetIndex = 0
        var progress:CGFloat = 0
        //2.targetIndex/progress计算
        let currentIndex = Int(startOffset / scrollView.bounds.width)
        
        if startOffset < scrollView.contentOffset.x {//手指左滑
            targetIndex = currentIndex + 1
            if targetIndex > childsVc.count - 1 {
                targetIndex = childsVc.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffset)/scrollView.bounds.width
        }else{
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffset - scrollView.contentOffset.x)/scrollView.bounds.width
        }
        
        //通知代理更新
        delegate?.contentScroll(self, target: targetIndex, progress: progress)
        
        
    }
    
    
    
}
