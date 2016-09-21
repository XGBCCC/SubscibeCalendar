//
//  SCUserCalendarService.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/24.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import SwiftyJSON
import CocoaLumberjackSwift

public class SCUserCalendarService {
    
    
    
    /**
     获取用户已订阅的日历Ids
     
     - parameter completionHandle: 操作完成后的回调,成功，会返回(CalendarIds,user_subscibe_calendarObjectIds)，失败，返回error
     
     */
    public class func SubscribedCalendarIds(completionHandle:SCCompletionHandler){
        
        SCAPIProvider.request(.SubscribedCalendar(Defaults[.userObjectId])) { (result) in
            switch result{
            case .Success(let response):
                //遍历获取到所有的calendar_objectId，然后在查询日历
                let json = JSON(data:response.data)
                var calendarIds = [String]()
                var userSubscibeCalendarObjectIds = [String]()
                
                if let calendarIdArray = json["results"].array {
                    for calendarIdJSON:JSON in calendarIdArray {
                        let calendar_objectId = calendarIdJSON["calendar_objectId"].stringValue
                        let userSubscibeCalendarObjectId = calendarIdJSON["objectId"].stringValue
                        
                        calendarIds.append(calendar_objectId)
                        userSubscibeCalendarObjectIds.append(userSubscibeCalendarObjectId)
                    }
                }
                
                let returnData = (calendarIds,userSubscibeCalendarObjectIds)
                
                completionHandle(result: .Success(returnData))
                
                
            case .Failure(let error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
        
    }
    
    /**
     日历订阅
     
     - parameter calendarId:       日历ID
     - parameter completionHandle: 操作完成后的回调,成功后需要返回订阅的ID
     */
    public class func SubscribeCalendar(calendarId:String,completionHandle:SCCompletionHandler){
        SCAPIProvider.request(.SubscribeCalendar(Defaults[.userObjectId],calendarId)) { (result) in
            switch result {
            case .Success(let response):
                let json = JSON(data:response.data)
                let userSubscibeId = json["objectId"].stringValue
                //同时，后台发送请求，更新Calendar的订阅数
                UpdateCalendarSubscibeCount(calendarId,op: "+"){(result) in }
                
                completionHandle(result: .Success(userSubscibeId))
            case let .Failure(error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
    }
    
    
    
    /**
     取消日历订阅
     
     - parameter userSubscribedId:  订阅ID
     - parameter userSubscribedId:  日历ID
     - parameter completionHandle: 操作完成后的回调
     */
    public class func UnSubscribeCalendar(userSubscribedId:String,calendarId:String,completionHandle:SCCompletionHandler){
        
        SCAPIProvider.request(.unSubscribeCalendar(userSubscribedId)) { (result) in
            switch result {
            case .Success(_):
                //同时，后台发送请求，更新Calendar的订阅数
                UpdateCalendarSubscibeCount(calendarId,op: "-"){(result) in }
                completionHandle(result: .Success(nil))
            case let .Failure(error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
    }
    
    public class func UpdateCalendarSubscibeCount(calendarId:String,op:String,completionHandle:SCCompletionHandler){
        CalendarStatisticsObjectId(calendarId) { (result) in
            switch result {
                
            case .Success(let calendar_statistics_objectId):
                if let objectId = calendar_statistics_objectId as! String? {
                    SCAPIProvider.request(.UpdateCalendarSubscibeCount(objectId,op)) {(result) in
                    
                        switch result {
                        
                        case .Success(let response):
                            completionHandle(result: .Success(response))
                        case .Failure(let error):
                            completionHandle(result: .Failure(NSError.ValidError(error)))
                        }
                        
                    }
                }
            case .Failure(let error):
                DDLogError("更新订阅数失败:\(error.domain)")
            
            }
        }
        
    }
    
    
    /**
     根据日历ID获取日历的统计信息ID
     
     - parameter calendarId:       日历ID
     - parameter completionHandle: 操作完成后的回调，返回日历统计信息的objectId
     */
    private class func CalendarStatisticsObjectId(calendarId:String,completionHandle:SCCompletionHandler){
        SCAPIProvider.request(.CalendarStatisticsObjectId(calendarId)) { (result) in
            switch result {
            case .Success(let response):
                var objectId = ""
                let json = JSON(data:response.data)
                if let objectArray = json["results"].array {
                    if let object = objectArray.first {
                        objectId = object["objectId"].stringValue
                    }
                }
                
                completionHandle(result: .Success(objectId))
                
            case let .Failure(error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
    }
    
}
