//
//  SCCalendarListCell.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/23.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import Kingfisher
import SubscibeCalendarKit

class SCCalendarListCell: UITableViewCell {
    
    @IBOutlet weak var calendarTitleLabel: UILabel!
    
    @IBOutlet weak var calendarDescriptionLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var coverContainerView: UIView!
    
    //点击事件
    var subscriptionButtonTapActoin:(()->Void)?
    
    func configWithCalendar(calendar:SCCalendar){
        calendarTitleLabel.text = calendar.calendar_title
        calendarDescriptionLabel.text = calendar.calendar_description
        
        let coverView = SCCoverView.CoverViewWithShowIn(SCCoverViewShowInType.CoverShowInListView, calendar: calendar, clickAction: nil)
        coverView.frame = coverContainerView.bounds
        self.coverContainerView.addSubview(coverView)
    }
    
    @IBAction func subscriptionButtonTouchUpInside(sender: UIButton) {
        subscriptionButtonTapActoin?()
    }
    
    class func CellIdentifier()->String{
        return "SCCalendarListCell"
    }
    
    
}
