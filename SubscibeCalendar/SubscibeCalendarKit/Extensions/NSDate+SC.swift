//
//  NSDate+SC.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/25.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation

public extension NSDate{
    public class func ValidDate(dateString:String,dateFormat:String) ->NSDate{
        //format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date:NSDate! = dateFormatter.dateFromString(dateString)
        
        return date
    }
    
    public class func StringWithDate(date:NSDate,dateFormat:String) ->String{
        //format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    public class func WeekdayStringWithDate(date:NSDate) -> String {
        let weekdays = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let calendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
        let timeZone = NSTimeZone(name: SCTimeZoneName)
        calendar?.timeZone = timeZone!;
        let calendarUnit = NSCalendarUnit.Weekday
        let thisComponents = calendar?.components(calendarUnit, fromDate: date)
        return weekdays[thisComponents!.weekday-1]
    }
}