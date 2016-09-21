//
//  SCCalendarService.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/22.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import SwiftyJSON

public class SCCalendarService {
    
    
    /**
     获取到推荐的日历
     
     - parameter page:             第几页
     - parameter completionHandle: 操作成功执行的闭包
     - parameter parse:            数据转换【Data->[Calendar]】如果是nil，则不进行转换，直接返回data
     */
    public class func CalendarsForRecommend(page:Int,completionHandle:SCCompletionHandler,parse:(NSData -> [SCCalendar])?){
    
        CalendarIdsForRecommend(page) { (result) in
            switch result {
            case let .Success(calendarIds):
                if let calendarIdArray = calendarIds as! [String]! {
                    
                    Calendars(calendarIdArray, completionHandle: { (result) in
                        
                        completionHandle(result: result)
                        
                    }, parse: parse)
                    
                }
            case let .Failure(error):
                completionHandle(result: .Failure(error))
            }
        }
    }
    
    
    /**
     获取推荐的日历Id
     
     - parameter page: 第几页【默认每页20条】
     - parameter completionHandle: 操作成功后的回调
     */
    public class func CalendarIdsForRecommend(page:Int,completionHandle:SCCompletionHandler) {
        SCAPIProvider.request(.CalendarIdsForRecommend(page)) { (result) in
            switch result{
            case let .Success(response):
                let json = JSON(data: response.data)
                var calendarIds = [String]()
                
                if let objectArray = json["results"].array {
                    for object:JSON in objectArray {
                        let calendar_objectId = object["calendar_objectId"].stringValue
                        calendarIds.append(calendar_objectId)
                    }
                }
                completionHandle(result: .Success(calendarIds))
                
            case let .Failure(error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
    }
    
    
    /**
     根据日历IDs获取到日历列表
     
     - parameter calendarIds:      日历ID Array
     - parameter completionHandle: 操作成功后的回调
     - parameter parse:            数据转换【Data->[Calendar]】如果是nil，则不进行转换，直接返回data
     */
    public class func Calendars(calendarIds:[String],completionHandle:SCCompletionHandler,parse:(NSData -> [SCCalendar])?){
        SCAPIProvider.request(.Calendars(calendarIds)) { (result) in
            switch result{
            case let .Success(response):
                if let parseAction = parse  {
                    completionHandle(result:.Success(parseAction(response.data)))
                }else{
                    completionHandle(result:.Success(response.data))
                }
            case let .Failure(error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
    }
    
    /**
     根据日历ID，获取日历事件列表
    
     - parameter calendarIds:       日历ID Array
     - parameter completionHandle: 操作成功后的回调
     - parameter parse:            数据转换 NSData -> ([String],[String:[SCCalendar_Event]]) 如果是nil，则不进行转换，直接返回data. 第一个[String]：所有有日历事件的日期,[String:[SCCalendar_event]]:String 是日期，SCCalendar_event是这个日期里面的所有日历事件
     */
    public class func CalendarEvents(calendarIds:[String],completionHandle:SCCompletionHandler,parse:(NSData -> ([String],[String:[SCCalendar_Event]]))?){
        SCAPIProvider.request(.CalendarEvents(calendarIds)) { (result) in
            switch result{
            case let .Success(response):
                
                if let parseAction = parse  {
                    completionHandle(result:.Success(parseAction(response.data)))
                }else{
                    completionHandle(result:.Success(response.data))
                }
                
            case let .Failure(error):
                completionHandle(result: .Failure(NSError.ValidError(error)))
            }
        }
    }
    
    
    
    
}