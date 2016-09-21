//
//  TodayViewController.swift
//  todaywidget
//
//  Created by JimBo on 16/6/27.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import NotificationCenter
import FSCalendar
import SubscibeCalendarKit
import CocoaLumberjackSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var calendarEventTableView: UITableView!
    
    private let calendarRowHeight:CGFloat = 36.0
    private let calendarViewDefaultHeight:CGFloat = 220
    
    //保存订阅的所有日历 key:日历objectId value:日历信息
    private var calendarDict:[String:SCCalendar] = [String:SCCalendar]()
    //key：日期  value：该日期的所有事件
    private var calendarEvents:[String:[SCCalendar_Event]] = [String:[SCCalendar_Event]]()
    //存储所有有事件的day：yyyy-MM-dd
    private var calendarDays:[String] = [String]()
    //当前选择的date
    private var currentSelectedDateKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //widget 的大小
        self.preferredContentSize = CGSizeMake(0, calendarViewDefaultHeight)
        
        calendarEventTableView.rowHeight = calendarRowHeight
        calendarEventTableView.tableHeaderView = UIView()
        calendarEventTableView.tableFooterView = UIView()
        calendarEventTableView.separatorColor = UIColor(hex: "838383")
        
        calendarView.appearance.titleFont = UIFont.systemFontOfSize(11)
        calendarView.appearance.weekdayTextColor = UIColor.whiteColor()
        calendarView.appearance.headerTitleColor = UIColor.whiteColor()
        calendarView.appearance.titleDefaultColor = UIColor.whiteColor()
        
        //获取数据
        //首先获取订阅的日历ID
        SCUserCalendarService.SubscribedCalendarIds { (result) in
            switch result{
            case let .Success(calendarIdArray):
                if let calendarIds = calendarIdArray as! [String]? {
                    //然后获取订阅的日历详情
                    SCCalendarService.Calendars(calendarIds, completionHandle: { (result) in
                        
                        switch result {
                            
                        case let .Success(calendarArray):
                            if let calendars = calendarArray as! [SCCalendar]? {
                                
                                //设置字典
                                for calendar in calendars {
                                    self.calendarDict[calendar.objectId] = calendar
                                }
                                
                                //再获取所有订阅的日历的所有事件
                                SCCalendarService.CalendarEvents(calendarIds, completionHandle: { (result) in
                                    
                                    switch result{
                                    case let .Success(calendarEvents):
                                        let object = calendarEvents as! ([String],[String:[SCCalendar_Event]])
                                        self.calendarDays = object.0
                                        self.calendarEvents = object.1
                                        
                                        self.calendarView.reloadData()
                                        self.calendarEventTableView.reloadData()
                                        
                                    case let .Failure(error):
                                        DDLogError("\(error)")
                                    }
                                    
                                    
                                    }, parse: SCCalendarEventParse)
                            }
                        case let .Failure(error):
                            DDLogError("\(error.domain)")
                        }
                        
                        }, parse: SCCalendarListParse)
                    
                }
            case let .Failure(error):
                DDLogError("\(error.domain)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    
    
}

//MARK: - TableView Delegate
extension TodayViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendarEventsForDay = calendarEvents[currentSelectedDateKey]{
            return calendarEventsForDay.count
        }
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if let calendarEventsForDay = calendarEvents[currentSelectedDateKey]{
            let calendarEvent = calendarEventsForDay[indexPath.row]
            
            let cell:TodayWidgetCalendarEventCell = tableView.dequeueReusableCellWithIdentifier(TodayWidgetCalendarEventCell.CellIdentifier(), forIndexPath: indexPath) as! TodayWidgetCalendarEventCell
            
            //获取tipColor
            var tipColorHex:String?
            if let calendar = self.calendarDict[calendarEvent.calendar_objectId]! as SCCalendar?{
                tipColorHex = calendar.calendar_tipColorHex
            }
            
            cell.configWithCalendarEvent(calendarEvent,calendarTipColorHex:tipColorHex)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("ToadyWidgetNoEventCell", forIndexPath: indexPath)
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let schemeURL:NSURL = NSURL(string: "xgbsubscibecalendar://")!
        self.extensionContext?.openURL(schemeURL, completionHandler: nil)
    }

}


//日历
extension TodayViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        currentSelectedDateKey = NSDate.StringWithDate(date, dateFormat: SCDateKeyFormatStyle)
        
        var preferredContentHeight = calendarViewDefaultHeight
        //获取数据的条数
        if let calendarEventsForDay = calendarEvents[currentSelectedDateKey]{
            preferredContentHeight = preferredContentHeight + CGFloat(calendarEventsForDay.count)*calendarRowHeight
        }else{
            preferredContentHeight = calendarViewDefaultHeight+calendarRowHeight
        }
        UIView.animateWithDuration(0.2) { 
            self.preferredContentSize = CGSizeMake(0, preferredContentHeight);
        }
        
        
        calendarEventTableView.reloadData()
        
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        let thisDateString = calendar.stringFromDate(date, format: SCDateKeyFormatStyle)
        if self.calendarDays.contains(thisDateString) {
            let thisCalendarEventsForDay = self.calendarEvents[thisDateString]!
            return thisCalendarEventsForDay.count
        }
        return 0
    }
    
    func calendar(calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorsForDate date: NSDate) -> [AnyObject]? {
        
        var colors:[UIColor] = [UIColor]()
        
        let thisDateString = calendar.stringFromDate(date, format: SCDateKeyFormatStyle)
        //如果这个日期包含有事件
        if self.calendarDays.contains(thisDateString){
            if let calendarEvents = calendarEvents[thisDateString] as [SCCalendar_Event]?{
                for calendarEvent:SCCalendar_Event in calendarEvents {
                    var tipColor = UIColor.init(hex: SCCalendarTipDefaultColor)
                    
                    let calendarId = calendarEvent.calendar_objectId
                    if let calendar = calendarDict[calendarId] as SCCalendar? {
                        if let colorHex = calendar.calendar_tipColorHex as String? {
                            tipColor = UIColor.init(hex: colorHex)
                        }
                    }
                    
                    colors.append(tipColor)
                }
            }
        }
        return colors
    }
}
