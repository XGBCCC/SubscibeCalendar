//
//  SCCalendarEventCell.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/16.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit

class SCCalendarEventCell: UITableViewCell {
    
    
    @IBOutlet weak var tipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var titleLabel_TipImageView_leading_LayoutConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.init(hex: "#292E33")
    }
    
    func configWithCalendarEvent(calendarEvent:SCCalendar_Event,calendarTipColorHex:String?){
        
        eventTitleLabel.text = calendarEvent.calendar_event_title
        timeLabel.text = NSDate.StringWithDate(calendarEvent.calendar_event_startTime, dateFormat: "HH:mm")
        if let colorHex = calendarTipColorHex {
            tipImageView.tintColor = UIColor.init(hex: colorHex)
            tipImageView.hidden = false
            titleLabel_TipImageView_leading_LayoutConstraint.constant = 10
        }else{
            tipImageView.hidden = true
            titleLabel_TipImageView_leading_LayoutConstraint.constant = -15
        }
    }

    class func CellIdentifier()->String{
        return "SCCalendarEventCell"
    }
    
}
