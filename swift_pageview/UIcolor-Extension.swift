//
//  UIcolor-Extension.swift
//  XMGTV
//
//  Created by 陈乐杰 on 2022/2/7.
//  Copyright © 2022 coderwhy. All rights reserved.
//


/**
 extension拓展原则
 1,无参数使用类方法拓展
 2,有参数使用便利构造函数拓展
 */


import UIKit

extension UIColor{
//    在extension中给类扩充构造函数,只能扩充便利构造函数,1.使用关键字convenience 2,使用指定构造函数
    /// RGB创建颜色
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat = 1.0){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /// 16进制
    /// - Parameters:
    ///   - hex: 16进制字符串
    ///   - alpha: 透明度
    convenience init?(hex:String, alpha:CGFloat = 1.0) {
        
        
        //1.判断字符串长度是否符合
        guard hex.count >= 6 else{
            return nil
        }
        //2,转大写
        let tmpHex = hex.uppercased()
        
        //3,截取后6位
        
        let hex = tmpHex.suffix(6) as NSString
        
        //4.分别取出RGB
        var rang = NSRange(location: 0, length: 2)
        let rHex = hex.substring(with:rang)
        rang = NSRange(location: 2, length: 2)
        let gHex = hex.substring(with:rang)
        rang = NSRange(location: 4, length: 2)
        let bHex = hex.substring(with:rang)
        
        //5.通过扫描器将16进制转换为10进制
        var r:UInt32 = 0,g:UInt32 = 0, b:UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)

        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
    
    
    /// 创建随机颜色
    /// - Returns:随机颜色
    class func randomColor()->UIColor{
       return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    /// 获取颜色差值,用于渐变设置
    /// - Parameters:
    ///   - firstColor: 第一个颜色,RGB的方式传入
    ///   - secondColor: 第二个颜色,RGB的方式传入
    /// - Returns: 颜色差值RGB
    class func getRGBDelta(_ firstColor:UIColor, _ secondColor:UIColor) -> (CGFloat,CGFloat,CGFloat){
        let firstCpms = firstColor.getRGB()
        let secondCpms = secondColor.getRGB()
        return (firstCpms.0 - secondCpms.0,firstCpms.1 - secondCpms.1,firstCpms.2 - secondCpms.2)
    }
    
    /// 获取颜色的RGB值
    /// - Returns: r,g,b
    func getRGB()->(CGFloat,CGFloat,CGFloat){
        guard let cpms = cgColor.components else{
            fatalError("需要以RGB的方式传入")
        }
        return (cpms[0]*255,cpms[1]*255,cpms[2]*255)
    }
    
}
