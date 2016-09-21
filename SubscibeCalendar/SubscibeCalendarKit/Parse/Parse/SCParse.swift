//
//  SCParse.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/23.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import SwiftyJSON


public struct SCCalendar {
    public let objectId:String
    public let calendar_title:String
    public let calendar_description:String?
    public let calendar_coverURL:String?
    public let calendar_tipColorHex:String?
    public let calendar_subscibed_count:Int
    
    public init(objectId:String,calendar_title:String,calendar_description:String?,calendar_coverURL:String?,calendar_tipColorHex:String?,calendar_subscibed_count:Int){
        self.objectId = objectId
        self.calendar_title = calendar_title
        self.calendar_description = calendar_description
        self.calendar_coverURL = calendar_coverURL
        self.calendar_tipColorHex = calendar_tipColorHex
        self.calendar_subscibed_count = calendar_subscibed_count
    }
}

public struct SCCalendar_Event {
    public let objectId:String
    public let calendar_event_title:String
    public let calendar_event_description:String?
    public let calendar_objectId:String
    public let calendar_date:NSDate
    public let calendar_event_startTime:NSDate
    public let calendar_event_endTime:NSDate
    
    
    public init(objectId:String,calendar_event_title:String,calendar_event_description:String?,calendar_objectId:String,calendar_date:NSDate
        ,calendar_event_startTime:NSDate,calendar_event_endTime:NSDate){
        
        self.objectId = objectId
        self.calendar_event_title = calendar_event_title
        self.calendar_event_description = calendar_event_description
        self.calendar_objectId = calendar_objectId
        self.calendar_date = calendar_date
        self.calendar_event_startTime = calendar_event_startTime
        self.calendar_event_endTime = calendar_event_endTime
        
    }
    
    public static func CalendarEventWithJSON(objectJSON:JSON) -> SCCalendar_Event{
        let calendar_date = dateWithJSON(objectJSON["calendar_date"])
        let calendar_event_startTime = dateWithJSON(objectJSON["calendar_event_startTime"])
        let calendar_event_entTime = dateWithJSON(objectJSON["calendar_event_endTime"])
        
        let calendar_event = SCCalendar_Event(objectId:objectJSON["objectId"].stringValue,calendar_event_title:objectJSON["calendar_event_title"].stringValue,calendar_event_description:objectJSON["calendar_event_description"].string,calendar_objectId:objectJSON["calendar_objectId"].stringValue,calendar_date:calendar_date
            ,calendar_event_startTime:calendar_event_startTime,calendar_event_endTime:calendar_event_entTime)
        return calendar_event;
    }
}

public let SCCalendarListParse : NSData -> [SCCalendar] = { data in
    
    var calendars = [SCCalendar]()
    
    let json = JSON(data:data)
    if let objectArray = json["results"].array {
        
        for object:JSON in objectArray {
            var subscribeCount = 0
            if let calendar_statistics = object["calendar_statistics"] as JSON? {
                subscribeCount = calendar_statistics["calendar_subscribeCount"].intValue
            }
            let calendar = SCCalendar(objectId:object["objectId"].stringValue,calendar_title:object["calendar_title"].stringValue,calendar_description:object["calendar_description"].string,calendar_coverURL:object["calendar_coverURL"].string,calendar_tipColorHex:object["calendar_tipColorHex"].string,calendar_subscibed_count:subscribeCount)
            calendars.append(calendar)
        }
    }
    
    return calendars
    
}

public let SCCalendarEventParse:NSData ->([String],[String:[SCCalendar_Event]]) = { data in

    var calendar_event_dict = [String:[SCCalendar_Event]]()
    var calendarDays = [String]()
    
    let json = JSON(data:data)
    if let objectArray = json["results"].array {
        
        for object:JSON in objectArray {
            
            let dateString = dateStringWithJSON(object["calendar_date"])
            
            let calendar_event = SCCalendar_Event.CalendarEventWithJSON(object);
            if calendar_event_dict[dateString] == nil{
                calendar_event_dict[dateString] = [SCCalendar_Event]()
                calendarDays.append(dateString)
            }
            
            var calendar_events:[SCCalendar_Event] = calendar_event_dict[dateString]!
            calendar_events.append(calendar_event)
            
            
            calendar_event_dict[dateString] = calendar_events
            
            
        }
    }
    
    return (calendarDays,calendar_event_dict)
}


public func dateWithJSON(dateJSON:JSON) -> NSDate {
    let dateString = dateJSON["iso"].stringValue
    let date = NSDate.ValidDate(dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    return date
}

public func dateStringWithJSON(dateJSON:JSON) -> String {
    let date = dateWithJSON(dateJSON)
    //转换格式
    let dateString = NSDate.StringWithDate(date, dateFormat: SCDateKeyFormatStyle)
    return dateString
}