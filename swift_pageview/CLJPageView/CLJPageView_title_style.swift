//
//  CLJPageView_title_style.swift
//  swift_pageview
//
//  Created by 陈乐杰 on 2022/2/7.
//

import UIKit

/// 顶部滚动条配置
class CLJPageView_title_style {
    
    /// 是否可滚动
    var isScrollEnable:Bool = true
    
    /// 高度
    var titleHeight = 44
    
    /// 普通颜色
    var normalColor:UIColor = UIColor(r: 0, g: 0, b: 0)
    
    /// 选中颜色
    var selectColor:UIColor = UIColor(r: 255, g: 127, b: 0)
    
    /// 普通字体大小
    var normalFont:CGFloat = 15.0
    
    /// 选中字体大小
    var selectFont:CGFloat = 18.0
    
    /// 滚动时的间距
    var itemMargin:CGFloat = 30
    
    /// 是否有滚动条
    var isShowScrollLine:Bool = false
    
    /// 滚动条高度
    var scrollLineHeight:CGFloat = 2
    
    /// 滚动条颜色
    var scrollLineColor:UIColor = .orange
}
