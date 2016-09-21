//
//  SCCalendarInfoHeaderView.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/30.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit
import Kingfisher

class SCCalendarInfoHeaderView: UIView {
    
    
    @IBOutlet weak var coverContainerView: UIView!
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    //底部功能区
    @IBOutlet weak var subscibeButton: UIButton!
    
    @IBOutlet weak var subscibedCountLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var shareCountLabel: UILabel!
    
    @IBOutlet weak var lookAtCalendarButton: UIButton!
    
    @IBOutlet weak var lookAtCalendarLabel: UILabel!
    
    var lookAtCalendarButtonAction:(()->Void)?
    var subscibeButtonAction:(()->Void)?
    var shareButtonAction:(()->Void)?
    
    override func awakeFromNib() {
        
        lookAtCalendarButton.imageView?.contentMode = .ScaleAspectFit
        lookAtCalendarButton.setImage(UIImage(named: "calendar_detail_icn_look"), forState: .Normal)
        
        subscibeButton.imageView?.contentMode = .ScaleAspectFit
        subscibeButton.setImage(UIImage(named: "calendar_detail_icn_subscibe"), forState: .Normal)
        
        shareButton.imageView?.contentMode = .ScaleAspectFit
        shareButton.setImage(UIImage(named: "calendar_detail_icn_share"), forState: .Normal)
        
    }
    
    func configWithCalendar(calendar:SCCalendar,coverViewClickedAction:()->()){
        
        
        let coverView = SCCoverView.CoverViewWithShowIn(.CoverShowInInfoView,calendar: calendar,clickAction:coverViewClickedAction)
        coverView.frame = self.coverContainerView.bounds
        self.coverContainerView.addSubview(coverView)
        self.subscibedCountLabel.text = ("\(calendar.calendar_subscibed_count)")
        self.calendarTitleLabel.text = calendar.calendar_title
        
    }
    
    func configSubscibeButtonWithSubscibeStatus(subscibedStatus:Bool){
        let imageName = subscibedStatus ? "calendar_detail_icn_subscibed" : "calendar_detail_icn_subscibe"
        subscibeButton.setImage(UIImage(named: imageName), forState: .Normal)
        
    }
    
    @IBAction func lookAtCalendarButtonClicked(sender: AnyObject) {
        if let action = lookAtCalendarButtonAction {
            action()
        }
    }
    
    
    @IBAction func subscibeButtonClicked(sender: AnyObject) {
        if let action = subscibeButtonAction {
            action()
        }
    }
   
    @IBAction func shareButtonClicked(sender: AnyObject) {
        if let action = shareButtonAction {
            action()
        }
    }
    
    
}
