//
//  SCCalendarViewController.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/15.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import FSCalendar
import SubscibeCalendarKit
import NVActivityIndicatorView
import CocoaLumberjackSwift

class SCCalendarViewController: UIViewController,NVActivityIndicatorViewable {
    

    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarContainerViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var calendarContainerViewTopSpaceLayout: NSLayoutConstraint!
    
    @IBOutlet weak var calendarView:FSCalendar!
    
    @IBOutlet weak var calendarEventTableView: UITableView!
    
    @IBOutlet var calendarContainerViewPanGesture: UIPanGestureRecognizer!
    
    
    private let calendarContainerViewDefaultHeightConstraint:CGFloat = 140
    private let calendarContainerViewDefaultYConstraint:CGFloat = 0
    private let calendarContainerViewAllMaxDropDownDistance:CGFloat = 200
    
    
    //保存订阅的所有日历 key:日历objectId value:日历信息
    private var calendarDict:[String:SCCalendar] = [String:SCCalendar]()
    //key：日期  value：该日期的所有事件
    private var calendarEvents:[String:[SCCalendar_Event]] = [String:[SCCalendar_Event]]()
    //存储所有有事件的day：yyyy-MM-dd
    private var calendarDays:[String] = [String]()
    //当前选择的date
    private var currentSelectedDateKey = ""
    
    //某个日历ID，如果设置了，则只显示这个日历的ID，不设置，则默认显示用户订阅的日历
    var calendarId:String?
    //当前VC显示的样式，主要用来设置navigation 默认：左边设置，右边今天  ShowWithCalendarId：左边返回，右边今天
    var calendarViewControllerShowType:SCCalendarViewControllerShowType = .Default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jz_navigationBarBackgroundAlpha = 1.0
        self.title = calendarView.stringFromDate(calendarView.currentPage, format: "yyyy年MM月")
        self.configNavigationBarItemWithShowType(calendarViewControllerShowType)
        
        calendarEventTableView.rowHeight = 45
        
        
        if let calendarId = self.calendarId {
    
            loadCalendarDataWithCalendarIds([calendarId])
            
        }else{
        
            //首先获取订阅的日历ID
            SCUserCalendarService.SubscribedCalendarIds { (result) in
                switch result{
                case let .Success(data):
                    if let calendarIdAndUserSubscibedIdArray = data as! ([String],[String])? {
                        self.loadCalendarDataWithCalendarIds(calendarIdAndUserSubscibedIdArray.0)
                    }
                    
                case let .Failure(error):
                    DDLogError("\(error.domain)")
                }
            }
        }
    

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if calendarEventTableView.tableFooterView == nil {
            let tableFooterViewHeight =  calendarEventTableView.frame.height - calendarEventTableView.rowHeight - tableView(calendarEventTableView, heightForHeaderInSection: 0)
            let tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.bounds.width, height: tableFooterViewHeight))
            calendarEventTableView.tableFooterView = tableFooterView
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: - TableView Delegate
extension SCCalendarViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return calendarDays.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let daykey = calendarDays[section]
        let calendarEventsForDay = calendarEvents[daykey]
        return calendarEventsForDay!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let daykey = calendarDays[indexPath.section]
        let calendarEvent = calendarEvents[daykey]![indexPath.row]
        
        let cell:SCCalendarEventCell = tableView.dequeueReusableCellWithIdentifier(SCCalendarEventCell.CellIdentifier(), forIndexPath: indexPath) as! SCCalendarEventCell
        //获取tipColor
        var tipColorHex:String?
        if let calendar = self.calendarDict[calendarEvent.calendar_objectId]! as SCCalendar?{
            tipColorHex = calendar.calendar_tipColorHex
        }
        cell.configWithCalendarEvent(calendarEvent,calendarTipColorHex:tipColorHex)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let daykey = calendarDays[indexPath.section]
        let calendarEvent = calendarEvents[daykey]![indexPath.row]
        
        let calendarEventInfoVC = Storyboards.Main.instantiateSCCalendarEventInfoViewController()
        calendarEventInfoVC.calendarEvent = calendarEvent
        
        self.navigationController?.pushViewController(calendarEventInfoVC, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell:SCCalendarEventHeaderCell = tableView.dequeueReusableCellWithIdentifier(SCCalendarEventHeaderCell.CellIdentifier()) as! SCCalendarEventHeaderCell
        let daykey = calendarDays[section]
        let date = NSDate.ValidDate(daykey, dateFormat: SCDateKeyFormatStyle)
        
        cell.configWithDate(date)
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        currentSelectedDateKey = calendarDays[indexPath.section]
        calendarView.selectDate(NSDate.ValidDate(currentSelectedDateKey, dateFormat: SCDateKeyFormatStyle), scrollToDate: true)
    }
}


//MARK: - FSCalendar Delegate
extension SCCalendarViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        self.title = calendar.stringFromDate(calendar.currentPage, format: "yyyy年MM月")
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        currentSelectedDateKey = NSDate.StringWithDate(date, dateFormat: SCDateKeyFormatStyle)
        
        var willScrollToIndexPath:NSIndexPath?;
        //判断这个日期是否有事件
        //如果有，则直接滑动到相应的section
        //如果没有，则找这天之后最近的日期，然后滑动
        //如果只有也没有了，则不滑动
        //底部tableview滑动到相应的section
        for (index,dateKey) in self.calendarDays.enumerate() {
            if dateKey.compare(self.currentSelectedDateKey) == NSComparisonResult.OrderedAscending || dateKey.compare(self.currentSelectedDateKey) == NSComparisonResult.OrderedSame{
             
                willScrollToIndexPath = NSIndexPath(forRow: 0, inSection: index)
            }
        }
        if let indexPath = willScrollToIndexPath {
            calendarEventTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        let thisDateString = calendar.stringFromDate(date, format: SCDateKeyFormatStyle)
        if self.calendarDays.contains(thisDateString) {
            let thisCalendarEventsForDay = self.calendarEvents[thisDateString]!
            return thisCalendarEventsForDay.count
        }
        return 0
    }
    
    func calendar(calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorForDate date: NSDate) -> UIColor? {
        let thisDateString = calendar.stringFromDate(date, format: SCDateKeyFormatStyle)
        if self.calendarDays.contains(thisDateString) {
            return UIColor.redColor()
        }
        return nil
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

//MARK: - 手势
extension SCCalendarViewController:UIGestureRecognizerDelegate {

    
    @IBAction func calendarContainerViewDropDownAction(panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .Ended,.Cancelled:
            calendarContainerViewTopSpaceLayout.constant = calendarContainerViewDefaultYConstraint
            
            UIView.animateWithDuration(0.4, animations: {
                
                self.view.layoutIfNeeded()
                
                }, completion: { (finish) in
                    
                panGesture.enabled = true
                
                    
            })
            break
        default:
            let dropDownDistance = max(panGesture.translationInView(calendarContainerView).y, 0)
            if dropDownDistance > calendarContainerViewAllMaxDropDownDistance {
                panGesture.enabled = false
            }else if dropDownDistance>0 {
                calendarContainerViewTopSpaceLayout.constant = calendarContainerViewDefaultYConstraint + dropDownDistance
            }
            break
        }
        
        
    }

}

//MERK: - Method
extension SCCalendarViewController {
    
    
    //加载日历数据
    func loadCalendarDataWithCalendarIds(calendarIds:[String]) {
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
    
    func scrollToCalendarTaday(){
        
        calendarView.selectDate(NSDate())
    }
}

//MARK: - Navigation
extension SCCalendarViewController {
    enum SCCalendarViewControllerShowType {
        case Default
        case ShowWithCalendarId
    }
    
    func configNavigationBarItemWithShowType(showType:SCCalendarViewControllerShowType){
        switch showType {
        case .Default:
            let leftBarItem = UIBarButtonItem(image: UIImage(named:"nav_setting"), style: .Plain, target: self, action: #selector(presentSettingViewController))
            self.navigationItem.leftBarButtonItem = leftBarItem
            break
        case .ShowWithCalendarId:
            break
        }
        
        let rightBarItem = UIBarButtonItem(title: "今天", style: .Plain, target: self, action: #selector(scrollToCalendarTaday))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func presentSettingViewController() {
        let settingVC = Storyboards.Main.instantiateSCSettingViewController()
        self.navigationController?.presentViewController(settingVC, animated: true, completion: nil)
    }
    
}