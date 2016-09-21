//
//  UIImage+SC.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/15.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    public class func ImageWithColor(color:UIColor,withFrame frame:CGRect)->UIImage{
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, frame)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public class func ImageWithColor(color:UIColor)->UIImage{
        return UIImage.ImageWithColor(color, withFrame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
    
}
