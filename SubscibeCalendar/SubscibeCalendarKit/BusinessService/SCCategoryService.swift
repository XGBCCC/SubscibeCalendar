//
//  SCCategoryService.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/22.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import SwiftyJSON
import CocoaLumberjackSwift

public class SCCategoryService {
    
    public class func Categorys(){
    
        SCAPIProvider.request(.Categorys) { (result) in
            switch result{
            case let .Success(response):
                let json = JSON(data: response.data)
                let resultArray = json["result"].array
                DDLogError("\(resultArray)")
            case let .Failure(error):
                DDLogError("\(error)")
                
            }
        }
        
    }
    
}

