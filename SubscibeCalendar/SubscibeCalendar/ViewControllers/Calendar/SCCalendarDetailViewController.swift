//
//  SCCalendarDetailViewController.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/30.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit
import SnapKit
import NVActivityIndicatorView
import CocoaLumberjackSwift

class SCCalendarDetailViewController: UIViewController,NVActivityIndicatorViewable {

    var calendar:SCCalendar?
    var calendarId:String?
    
    
    @IBOutlet weak var bgBlurView: UIView!
    @IBOutlet weak var calendarInfoContainerView: UIView!
    @IBOutlet weak var calendarInfoDescLabel: UITextView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    private let bgBlurViewDefaultHeight:CGFloat = 290
    private var subscibed:Bool = false
    
    //所有的订阅ID
    private var userSubscibedId:String?
    
    private var calendarInfoHeaderView:SCCalendarInfoHeaderView = NSBundle.mainBundle().loadNibNamed("SCCalendarInfoHeaderView", owner: nil, options: nil)[0] as! SCCalendarInfoHeaderView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let calendar = calendar {
            self.configWithCalendar(calendar)
        }else{
            //根据ID获取日历信息
            if let calendarId = calendarId {
            SCCalendarService.Calendars([calendarId], completionHandle: { (result) in
                
                switch result {
                    
                case let .Success(calendarArray):
                    if let calendars = calendarArray as! [SCCalendar]? {
                        if calendars.count > 0{
                            self.calendar = calendars[0]
                            if let calendar = self.calendar {
                                self.configWithCalendar(calendar)
                            }
                        }
                    }
                case let .Failure(error):
                    print("\(error.domain)")
                }
                
                }, parse: SCCalendarListParse)

            }
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension SCCalendarDetailViewController{

    func configWithCalendar(calendar:SCCalendar){
        
        //判断是否已订阅
        self.startActivityAnimating()
        SCUserCalendarService.SubscribedCalendarIds({ (result) in
            self.stopActivityAnimating()
            switch result {
            case .Success(let data):
                if let data = data as! ([String],[String])? {
                    
                    self.subscibed = data.0.contains(calendar.objectId)
                    if(self.subscibed){
                        if let index = data.0.indexOf(calendar.objectId) {
                            self.userSubscibedId = data.1[index]
                        }
                    }
                    self.calendarInfoHeaderView.configSubscibeButtonWithSubscibeStatus(self.subscibed)
                }
            case .Failure(let error):
                DDLogError("\(error.domain)")
            }
        })
        
        
        calendarInfoHeaderView.configWithCalendar(calendar) {
            
        }
        
        calendarInfoHeaderView.lookAtCalendarButtonAction = {
            let calendarViewController = Storyboards.Main.instantiateSCCalendarViewController()
            calendarViewController.calendarId = calendar.objectId
            calendarViewController.calendarViewControllerShowType = .ShowWithCalendarId
            self.navigationController?.pushViewController(calendarViewController, animated: true)
        }
        
        calendarInfoHeaderView.subscibeButtonAction = {
            
            self.startActivityAnimating()
            if self.subscibed {
                
                //首先需要获取订阅的ID，然后才能取消
                if let userSubscibedId = self.userSubscibedId {
                    //取消订阅
                    SCUserCalendarService.UnSubscribeCalendar(userSubscibedId,calendarId: calendar.objectId, completionHandle: { (result) in
                        self.stopActivityAnimating()
                        switch result{
                        case .Success(_):
                            self.calendarInfoHeaderView.configSubscibeButtonWithSubscibeStatus(false)
                            self.subscibed = false
                        case .Failure(let error):
                            DDLogError("\(error.domain)")
                        }
                    })
                }
            }else{
                //订阅
                SCUserCalendarService.SubscribeCalendar(calendar.objectId, completionHandle: { (result) in
                    self.stopActivityAnimating()
                    switch result{
                    case .Success(let userSubscibedId):
                        self.calendarInfoHeaderView.configSubscibeButtonWithSubscibeStatus(true)
                        self.subscibed = true
                        self.userSubscibedId = userSubscibedId as! String?
                    case .Failure(let error):
                        DDLogError("\(error.domain)")
                    }
                })
            }
        }
        
        calendarInfoHeaderView.frame = CGRect(x: 0, y: 0, width: calendarInfoContainerView.frame.width, height: calendarInfoContainerView.frame.height)
        calendarInfoContainerView.addSubview(calendarInfoHeaderView)
        calendarInfoHeaderView.snp_makeConstraints(closure: { (make) in
            make.leading.bottom.top.trailing.equalTo(calendarInfoContainerView)
        })
        
        
        if let coverURL = calendar.calendar_coverURL {
            self.bgImageView.kf_setImageWithURL(NSURL(string:coverURL)!, placeholderImage: UIImage.init(named: "calendar_detail_icn_bg"))
        }
        
        calendarInfoDescLabel.text = calendar.calendar_description
        calendarInfoDescLabel.selectable = false
        
    }
    
}
