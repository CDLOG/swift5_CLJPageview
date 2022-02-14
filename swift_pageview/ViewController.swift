//
//  ViewController.swift
//  swift_pageview
//
//  Created by 陈乐杰 on 2022/2/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //标题view相关初始化
        let titles = ["游戏","娱乐","直播","风景风景风景","游戏游戏游戏","娱乐","直播","风景"]
        //titleview配置
        let titleStyle = CLJPageView_title_style()
        titleStyle.titleHeight = 45
        //可滚动
        titleStyle.isShowScrollLine = true
        //内容控制器相关初始化
        var childs = [UIViewController]()
        for _ in titles {
            let vc = UIViewController()
            //控制器背景色
            vc.view.backgroundColor = UIColor.randomColor()
            //改成自己需要的控制器
            childs.append(vc)
        }
        //分页控件初始化
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        let pageView = CLJPageView(frame: frame, titles: titles, childsVC: childs, parentVc: self, titleStyle: titleStyle)
        
        view.addSubview(pageView)
        
        
    }

    

}

