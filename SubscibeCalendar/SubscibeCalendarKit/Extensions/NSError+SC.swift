//
//  NSError+SC.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/22.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public extension NSError {
    public class func ValidError(error: Moya.Error)->NSError {
        var responseStr = "未获取到数据"
        if let response = error.response {
            responseStr = String(data: response.data, encoding: NSUTF8StringEncoding)!
        }
        let errorInfo = NSError(domain: responseStr, code: error._code, userInfo: nil)
        return errorInfo
    }
}