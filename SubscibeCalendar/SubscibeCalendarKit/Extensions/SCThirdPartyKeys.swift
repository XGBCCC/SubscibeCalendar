//
//  SCThirdPartyKeys.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/21.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation

public struct SCThirdPartyKeys {
    public struct Weibo {
        public static let appID = "*******"
        public static let appKey = "*******"
        public static let redirectURL = "https://api.weibo.com/oauth2/default.html"
    }
    
    public struct Wechat {
        public static let appID = "*******"
        public static let appKey = "*******"
    }
    
    public struct QQ {
        public static let appID = "*******"
    }
    
    public struct Pocket {
        public static let appID = "*******"
        public static let redirectURL = "*******" // pocketapp + $prefix + :authorizationFinished
    }
    
    public struct Alipay {
        public static let appID = "*******"
    }
    
    public struct LeanCloud {
        public static let XLCId = "*******"
        public static let XLCKey = "*******"
    }
}
