//
//  Extensions.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/15.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import Result
import CocoaLumberjack
import CocoaLumberjackSwift

//typealias SCCompletionHandler = (errorTip:String?) -> Void
//typealias SCCompletionHandler = (result:Result<object:Array,error:NSError?>) -> Void
public typealias SCCompletionHandler = (result:Result<Any?,NSError>) -> ()


/**
 延后执行
 
 - parameter delay:   几秒后
 - parameter closure: 执行回调
 */
public func delay(delay:Double, closure:()->())
{
    dispatch_after( dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue(), closure)
}

/**
 Data转为JSON格式的Data
 
 - parameter data: 原始的Data
 
 - returns: JSON格式的Data
 */
public func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =  try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

/**
 生成高斯模糊图片
 
 - parameter image: 原图
 
 - returns: 高斯模糊图片
 */
public func SCGaussianBlurImageWithImage(image:UIImage) -> UIImage {
    let originCIImage = CIImage(image:image)
    let extent = (originCIImage?.extent)!
    //创建高斯模糊滤镜
    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(originCIImage, forKey: kCIInputImageKey)
    filter?.setValue(NSNumber(float:5), forKey: kCIInputRadiusKey)
    
    //生成图片
    let blurCIImage:CIImage = (filter?.outputImage)!
    UIGraphicsBeginImageContextWithOptions(extent.size, false, 0)
    UIImage(CIImage: blurCIImage).drawInRect(extent)
    let blurImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return blurImage
}

/**
 与print方法对应的DDLog的print方法
 
 - parameter items:      要打印的东西
 - parameter separator:  分隔符
 - parameter terminator: 结束符
 */
public func DDPrint(items: Any..., separator: String = ",", terminator: String = "\n"){
    var infoStr = ""
    for (index,item) in items.enumerate() {
        infoStr+=String(item)
        if index<items.count-1 {
            infoStr+=separator
        }
    }
    infoStr+=terminator
    
    DDLogVerbose(infoStr)
}