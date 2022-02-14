//
//  CLJPageView_title.swift
//  swift_pageview
//
//  Created by 陈乐杰 on 2022/2/7.
//

import UIKit

protocol CLJPageView_titleDelete : AnyObject{
    func titlesView(_ titlesView:CLJPageView_title,selectIndex:Int)
}
class CLJPageView_title: UIView {
    weak var delegate:CLJPageView_titleDelete?
    fileprivate var titles:[String]
    fileprivate var style:CLJPageView_title_style
    //当前选中的Lable
    fileprivate lazy var currentSelectLableIndex:Int = 0
    //数组保存所有的titleLable
    fileprivate lazy var scrollLables:[UILabel] = [UILabel]()
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollV = UIScrollView(frame: self.bounds)
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.scrollsToTop = false
        return scrollV
    }()
    
    fileprivate lazy var bottomLine:UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = style.scrollLineColor
        bottomLine.frame.size.height = style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - style.scrollLineHeight
        return bottomLine
    }()
    
    init(frame: CGRect,titles:[String],style:CLJPageView_title_style) {
        
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - ui设置
extension CLJPageView_title{
    fileprivate func setupUI(){
        //1.将scrollview添加到titleview中
        addSubview(scrollView)
        //2.将titlelable添加到scrollview中
        setupTitleLables()
        //3,设置titleLable的frame
        setupTitleLableFrame()
        //4.添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
       
    }
    private func setupTitleLables(){
        for (i,title) in titles.enumerated() {
            let titleLable = UILabel()
            titleLable.text = title
            //默认选中第一个lable
            titleLable.textColor = i == 0 ? style.selectColor : style.normalColor
            
            titleLable.font = UIFont.systemFont(ofSize: style.normalFont)
            titleLable.tag = i
            titleLable.textAlignment = .center
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(titleLableClick(_:)))
            titleLable.addGestureRecognizer(gesture)
            //必须设置lable可交互点击手势才有效
            titleLable.isUserInteractionEnabled = true
            
            scrollView.addSubview(titleLable)
            scrollLables.append(titleLable)
        }
        
    }
    
    private func setupTitleLableFrame(){
        let count = scrollLables.count
        for (i,lable) in scrollLables.enumerated() {
            var x:CGFloat = 0
            let y:CGFloat = 0
            var w:CGFloat = 0
            let h:CGFloat = bounds.height
            
            
            if style.isScrollEnable{
                //标题可以滚动
                w = (lable.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:lable.font ?? 15], context: nil).width
                if i == 0 {
                    x = style.itemMargin / 2
                    if style.isShowScrollLine{
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w 
                    }
                    
                }else{
                    let preLable = scrollLables[i - 1]
                    x = preLable.frame.maxX + style.itemMargin
                    
                    
                }
            }else{
                //标题不可以滚动
                w = bounds.width/CGFloat(count)
                x = w * CGFloat(i)
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
                
            }
            lable.frame = CGRect(x: x, y: y, width: w, height: h)
            scrollView.contentSize = style.isScrollEnable ? CGSize(width: scrollLables.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
        }
    }
}

// MARK: - 监听事件
extension CLJPageView_title{
    
    /// 点击Lable
    /// - Parameter gesture: 手势
    @objc fileprivate func titleLableClick(_ gesture:UITapGestureRecognizer){
//        1.获取用户点击的lable
        let selectLable = gesture.view as! UILabel
//        2.调整title
        adjustTitleLable(targetIndex: selectLable.tag)
//        2.1调整底部滚动条
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = selectLable.frame.origin.x
                self.bottomLine.frame.size.width = selectLable.frame.size.width
            }
        }
        
//        3,代理通知切换VC
        delegate?.titlesView(self, selectIndex: currentSelectLableIndex)
        
    }
    
    
    /// 更新LableUI
    /// - Parameter targetIndex: 当前选中的lable
    fileprivate func adjustTitleLable(targetIndex:Int){
        
        
        if currentSelectLableIndex == targetIndex{return}
        
//        1.获取用户点击的lable
        let selectLable = scrollLables[targetIndex]
        //上一个选中的Lable
        let sourcelable = scrollLables[currentSelectLableIndex]
//        2.更改lable 的颜色
        
        selectLable.textColor = style.selectColor
        sourcelable.textColor = style.normalColor
        
//        3.更新当前选中的lable
        currentSelectLableIndex = selectLable.tag
        
//        4.调整位置
        if style.isScrollEnable {
            var offset = selectLable.center.x - scrollView.bounds.width * 0.5
            
            
            if offset < 0{
                offset = 0
            }
            if offset > (scrollView.contentSize.width - scrollView.bounds.width){
                offset = scrollView.contentSize.width - scrollView.bounds.width
            }
            
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    
}
// MARK: - 代理响应颜色渐变
extension CLJPageView_title:CLJPageView_contentDelegate{
    func contentScroll(_ content: CLJPageView_content, target: Int) {
         adjustTitleLable(targetIndex: target)
    }
    func contentScroll(_ content: CLJPageView_content, target: Int, progress: CGFloat) {
//        1.取出lable
        let selectLable = scrollLables[target]
        let sourcelable = scrollLables[currentSelectLableIndex]
        
//        2.颜色渐变
        let rGBDelta = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        selectLable.textColor = UIColor(r: normalRGB.0 + rGBDelta.0 * progress, g: normalRGB.1 + rGBDelta.1 * progress, b: normalRGB.2 + rGBDelta.2 * progress)
        sourcelable.textColor = UIColor(r: selectRGB.0 - rGBDelta.0 * progress , g: selectRGB.1 - rGBDelta.1 * progress, b: selectRGB.2 - rGBDelta.2 * progress)
        
//        3.底部滚动条渐变
        if style.isShowScrollLine {
            let deltaX = selectLable.frame.origin.x - sourcelable.frame.origin.x
            let deltaW = selectLable.frame.size.width - sourcelable.frame.size.width
            bottomLine.frame.origin.x = sourcelable.frame.origin.x + (deltaX * progress)
            bottomLine.frame.size.width = sourcelable.frame.size.width + deltaW * progress
        }
        
        
    }
    
}
