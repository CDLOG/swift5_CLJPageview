//
//  CLJPageView.swift
//  swift_pageview
//
//  Created by 陈乐杰 on 2022/2/7.
//

import UIKit



class CLJPageView: UIView {
    
    fileprivate var titles:[String]
    fileprivate var childsVc:[UIViewController]
    fileprivate var parentsVc:UIViewController
    fileprivate var titleStyle:CLJPageView_title_style
    fileprivate var titlesView:CLJPageView_title!
    init(frame:CGRect, titles:[String], childsVC:[UIViewController],parentVc:UIViewController,titleStyle:CLJPageView_title_style){
        
        self.titles = titles;
        self.childsVc = childsVC
        self.parentsVc = parentVc
        self.titleStyle = titleStyle
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension CLJPageView{
    fileprivate func setupUI(){
        setupTitleView()
        setupContentView()
    }
    private func setupTitleView(){
        let frame = CGRect(x: 0, y: 0, width:Int(bounds.width), height: titleStyle.titleHeight)
        titlesView = CLJPageView_title(frame: frame, titles: titles,style: titleStyle)
        titlesView.backgroundColor = UIColor.randomColor()
        addSubview(titlesView!)
    }
    private func setupContentView(){
        let frame = CGRect(x: 0, y: titlesView.frame.maxY  , width: bounds.width, height: bounds.height - titlesView.bounds.height)
        let contentView = CLJPageView_content(frame: frame, childsVc: childsVc, parents: parentsVc)
        contentView.backgroundColor = UIColor.randomColor()
        //设置代理,切换VC
        titlesView.delegate = contentView
        contentView.delegate = titlesView
        addSubview(contentView)
    }
}
