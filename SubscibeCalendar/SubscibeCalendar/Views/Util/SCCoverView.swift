//
//  SCCoverView.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/30.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit

enum SCCoverViewShowInType {
    //列表页，只显示有多少人订阅
    case CoverShowInListView
    //详情页，会多显示个详情按钮，点击会弹出详情页
    case CoverShowInInfoView
}

class SCCoverView: UIView {
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var subscriptionCountLabel: UILabel!
    
    @IBOutlet weak var infoImageView: UIImageView!
    
    private var clickAction:(()->())?
    private var calendar:SCCalendar?
    
    
    class func CoverViewWithShowIn(coverShowType:SCCoverViewShowInType,calendar:SCCalendar,clickAction:(()->())?) -> SCCoverView{
    
        let coverView = NSBundle.mainBundle().loadNibNamed("SCCoverView", owner: nil, options: nil)[0] as! SCCoverView
        
        coverView.subscriptionCountLabel.text = ("\(calendar.calendar_subscibed_count)")
        
        switch coverShowType {
        case .CoverShowInListView:
            coverView.infoImageView.hidden = true
            
        case .CoverShowInInfoView:
            coverView.infoImageView.hidden = false
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(viewTouchUpInsideAction(_:)))
            coverView.gestureRecognizers?.append(tapGesture)
        }
        
        if let calendarCoverURLString = calendar.calendar_coverURL {
            coverView.coverImageView.kf_setImageWithURL(NSURL(string:calendarCoverURLString)!, placeholderImage: nil)
        }
        
        coverView.clickAction = clickAction
        coverView.calendar = calendar;
        
        return coverView
    }
    
    func viewTouchUpInsideAction(sender: AnyObject) {
        
        if let clickAction = self.clickAction{
            clickAction()
        }
        
    }
    
    
}
