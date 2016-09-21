//
//  SCGradientView.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/29.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit

class SCGradientView: UIView {
    private var gradientLayer:CAGradientLayer?

    override func drawRect(rect: CGRect) {
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer!.colors = [UIColor.init(hex: "000000", alpha: 0.2).CGColor,UIColor.init(hex: "ffffff", alpha: 0).CGColor]
            gradientLayer!.startPoint = CGPointMake(1, 0)
            gradientLayer!.endPoint = CGPointMake(0, 0)
            gradientLayer!.frame = self.bounds
            self.layer.addSublayer(gradientLayer!)
        }
    }

}
