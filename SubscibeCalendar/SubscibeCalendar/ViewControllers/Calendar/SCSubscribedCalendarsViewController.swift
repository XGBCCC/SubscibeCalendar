//
//  SCSubscribedCalendarsViewController.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/7/4.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit
import NVActivityIndicatorView
import Whisper


class SCSubscribedCalendarsViewController: UITableViewController,NVActivityIndicatorViewable {
    
    private var calendars:[SCCalendar] = [SCCalendar]()
    //所有的订阅ID
    private var userSubscibedIds:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib.init(nibName: "SCCalendarListCell", bundle: nil), forCellReuseIdentifier: SCCalendarListCell.CellIdentifier())
        self.tableView.tableFooterView = UIView()
        
        SCUserCalendarService.SubscribedCalendarIds { (result) in
            switch result{
            case .Success(let data):
                if let data = data as! ([String],[String])? {
                    
                    self.userSubscibedIds = data.1
                    SCCalendarService.Calendars(data.0, completionHandle: { (result) in
                        
                        switch result {
                            
                        case let .Success(calendarArray):
                            if let calendars = calendarArray as! [SCCalendar]? {
                                self.calendars = calendars
                                self.tableView.reloadData()
                            }
                        case let .Failure(error):
                            print("\(error.domain)")
                        }
                        
                        }, parse: SCCalendarListParse)
                    
                }
                
            case .Failure(let error):
                print(("\(error)"))
            }
        }
    }
    
}

//MARK: - tableviewDelgate
extension SCSubscribedCalendarsViewController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendars.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SCCalendarListCell = tableView.dequeueReusableCellWithIdentifier(SCCalendarListCell.CellIdentifier(), forIndexPath: indexPath) as! SCCalendarListCell
        let calendar = self.calendars[indexPath.row]
        cell.configWithCalendar(calendar)
        
        
        cell.subscriptionButtonTapActoin = {
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let calendar = calendars[indexPath.row]
        let userSubcibedId = userSubscibedIds[indexPath.row]
        let unSubcribeAction = UITableViewRowAction(style: .Default, title: "取消订阅") { (action, indexPath) in
            
            
            self.startActivityAnimating()
            
            SCUserCalendarService.UnSubscribeCalendar(userSubcibedId,calendarId: calendar.objectId, completionHandle: { (result) in
                self.stopActivityAnimating()
                switch result {
                case .Success(_):
                    self.calendars.removeAtIndex(indexPath.row)
                    self.userSubscibedIds.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                case .Failure(_):
                    let murmur = Murmur(title: "操作失败",
                        backgroundColor: UIColor.SCStatusBarTipBackgroundColor(),
                        titleColor: UIColor.whiteColor())
                    show(whistle: murmur)
                }
                
            })
        }
        return [unSubcribeAction]
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 111.0
    }
}
