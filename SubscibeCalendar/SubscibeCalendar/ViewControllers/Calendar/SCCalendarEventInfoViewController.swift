//
//  SCCalendarEventInfoViewController.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/7/4.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit

class SCCalendarEventInfoViewController: UITableViewController {
    
    
    var calendarEvent:SCCalendar_Event?
    var simulationCell:SCCalendarEventTitleCell = NSBundle.mainBundle().loadNibNamed("SCCalendarEventTitleCell", owner: nil, options: nil)[0] as! SCCalendarEventTitleCell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:SCCalendarEventTitleCell = tableView.dequeueReusableCellWithIdentifier(SCCalendarEventTitleCell.CellIdentifier(), forIndexPath: indexPath) as! SCCalendarEventTitleCell
            
            cell.titleLabel.text = calendarEvent?.calendar_event_title
            
            return cell
        }else{
            let cell:SCCalendarEventTimeCell = tableView.dequeueReusableCellWithIdentifier(SCCalendarEventTimeCell.CellIdentifier(), forIndexPath: indexPath) as! SCCalendarEventTimeCell
            if let calendarEvent = calendarEvent {
                let weekDayString = NSDate.WeekdayStringWithDate(calendarEvent.calendar_date)
                let dateString = NSDate.StringWithDate(calendarEvent.calendar_date, dateFormat: "yyyy年MM月dd日")
                
                cell.dateLabel.text = ("\(dateString) \(weekDayString)")
                
                let startTimeString = NSDate.StringWithDate(calendarEvent.calendar_event_startTime, dateFormat: "HH:mm")
                let endTimeString = NSDate.StringWithDate(calendarEvent.calendar_event_endTime, dateFormat: "HH:mm")
                cell.timeLabel.text = ("从 \(startTimeString) 到 \(endTimeString)")
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if let calendarEvent = calendarEvent {
                let weekDayString = NSDate.WeekdayStringWithDate(calendarEvent.calendar_date)
                let dateString = NSDate.StringWithDate(calendarEvent.calendar_date, dateFormat: "yyyy年MM月dd日")
                simulationCell.titleLabel.text = ("\(dateString) \(weekDayString)")
                let size = simulationCell.systemLayoutSizeFittingSize(CGSizeMake(tableView.frame.width, 1000))
                return size.height
            }
            return 0
        }else {
            return 15+20+5+20+15
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
}
