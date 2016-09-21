//
//  AppDelegate.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/14.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import MonkeyKing
import SubscibeCalendarKit
import NVActivityIndicatorView
import Fabric
import Crashlytics
import CocoaLumberjack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        SCConfig.config()
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let urlComponents = NSURLComponents(string: url.absoluteString)
        let queryItems = urlComponents?.queryItems
        if (url.absoluteString.containsString("shareAndInvocationToSubscibe?calendarId=")) == true {
            let calendarIdItem = queryItems?.filter({ (obj) -> Bool in
                obj.name == "calendarId"
            }).first
            
            let calendarDetailVC = Storyboards.Main.instantiateSCCalendarDetailViewController()
            calendarDetailVC.calendarId = calendarIdItem?.value
            let navigaionVC = UINavigationController(rootViewController: calendarDetailVC)
            self.window?.rootViewController?.presentViewController(navigaionVC, animated: true, completion: nil)
        }
        //三方登录
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        
        
        
        return false
    }
    
    
    
}


/**
 添加本地推送
 
 - parameter fireDate: 推送时间
 - parameter title:    推送标题
 - parameter body:     推送内容
 */
func scheduleLocalNotification(fireDate:NSDate,title:String,body:String){
    //本地推送测试
    let localNotification = UILocalNotification()
    
    let fireDate = NSDate().dateByAddingTimeInterval(60)
    localNotification.fireDate = fireDate
    localNotification.timeZone = NSTimeZone(name: SCTimeZoneName)
    
    localNotification.alertTitle = title
    localNotification.alertBody = body
    
    localNotification.soundName = UILocalNotificationDefaultSoundName
    
    localNotification.applicationIconBadgeNumber = 1;
    
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
}
