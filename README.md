# swift5_CLJPageview
基于swift5封装的分页控件


代码基于swift5.0

预览
![在这里插入图片描述](https://img-blog.csdnimg.cn/7e6881c2d34f4cc783b274a6847f9b76.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Yqq5Yqb5L-u56aP5oql,size_13,color_FFFFFF,t_70,g_se,x_16)
封装的简单分页控制器，简单易用

初始化代码
```
/标题view相关初始化
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
```
顶部滚动条可配置属性如下
```
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
```
