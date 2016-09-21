//
//  TodayWidgetCalendarEventCell.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/27.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit

class TodayWidgetCalendarEventCell: UITableViewCell {
    
    @IBOutlet weak var calendarEventTitleLabel: UILabel!
    
    @IBOutlet weak var calendarEventTimeLabel: UILabel!
    @IBOutlet weak var calendarTagImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(hex: "#7A7A7D")
    }
    
    func configWithCalendarEvent(calendarEvent:SCCalendar_Event,calendarTipColorHex:String?){
        self.calendarEventTitleLabel.text = calendarEvent.calendar_event_title
        if let colorHex = calendarTipColorHex as String?{
            calendarTagImageView.tintColor = UIColor.init(hex: colorHex)
        }else{
            
        }
    }

    
    class func CellIdentifier()->String {
        return "TodayWidgetCalendarEventCell"
    }
}
