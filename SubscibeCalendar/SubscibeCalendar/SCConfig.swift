//
//  SCConfig.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/7/7.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import MonkeyKing
import SubscibeCalendarKit
import NVActivityIndicatorView
import Fabric
import Crashlytics
import CocoaLumberjack

class SCConfig {

    static let defaultLogLevel: DDLogLevel = DDLogLevel.Verbose

    class func config(){
    
        Fabric.with([Crashlytics.self])
        
        //loading 配置
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSizeMake(30, 30)
        NVActivityIndicatorView.DEFAULT_TYPE = .Pacman
        
        //Log 设置
        
        DDLog.addLogger(DDTTYLogger.sharedInstance(),withLevel: defaultLogLevel)
        DDLog.addLogger(DDASLLogger.sharedInstance(),withLevel: defaultLogLevel)
        let fileLogger:DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60*60*24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 2
        DDLog.addLogger(fileLogger)
        
        
        //Navigation
        UINavigationBar.appearance().setBackgroundImage(UIImage.ImageWithColor(UIColor.SCNavigationBarBackgroundColor()), forBarMetrics: .Default)
        UINavigationBar.appearance().tintColor = UIColor.SCNavigationBarTintColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.SCNavigationBarTitleColor()]
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //注册推送
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert,.Badge,.Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        //注册第三方登录
        MonkeyKing.registerAccount(.Weibo(appID: SCThirdPartyKeys.Weibo.appID, appKey: SCThirdPartyKeys.Weibo.appKey, redirectURL: SCThirdPartyKeys.Weibo.redirectURL))
    }
    
}