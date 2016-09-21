//
//  SCCalendarListViewController.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/23.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit
import CocoaLumberjackSwift

class SCCalendarListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var calendars:[SCCalendar] = [SCCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jz_navigationBarBackgroundHidden = false
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.registerNib(UINib.init(nibName: "SCCalendarEventTitleCell", bundle: nil), forCellReuseIdentifier: SCCalendarEventTitleCell.CellIdentifier())
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0,y: 0,width: tableView.bounds.width,height: 10))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: tableView.bounds.width,height: 10))
        
        SCCalendarService.CalendarsForRecommend(0, completionHandle: { (result) in
            switch result{
            case .Success(let calendarList):
                self.calendars = calendarList as! [SCCalendar]
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
            case .Failure(let error):
                DDLogError("\(error)")
            }
        }, parse: SCCalendarListParse)
        
    }
}

extension SCCalendarListViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendars.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SCCalendarListCell = tableView.dequeueReusableCellWithIdentifier(SCCalendarListCell.CellIdentifier(), forIndexPath: indexPath) as! SCCalendarListCell
        let calendar = self.calendars[indexPath.row]
        cell.configWithCalendar(calendar)
        
        
        cell.subscriptionButtonTapActoin = {
        
            SCUserCalendarService.SubscribeCalendar(calendar.objectId, completionHandle: { (result) in
                
            })
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 111.0
    }
}

//MARK: -  Storyboard相关
extension SCCalendarListViewController{

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let clickedCell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(clickedCell)
        let calendar = calendars[indexPath!.row]
        
        let calendarDetailVC = segue.destinationViewController as! SCCalendarDetailViewController
        calendarDetailVC.calendar = calendar
        
        calendarDetailVC.jz_navigationBarBackgroundHidden = true
    }
    
}

