//
//  SCCalendarEventHeaderCell.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/16.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SubscibeCalendarKit

class SCCalendarEventHeaderCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    func configWithDate(date:NSDate){
        let weekDayString = NSDate.WeekdayStringWithDate(date)
        let dateString = NSDate.StringWithDate(date, dateFormat: SCDateKeyFormatStyle)
        
        dateLabel.text = "\(weekDayString)  \(dateString)"
    }
    
    class func CellIdentifier()->String{
        return "SCCalendarEventHeaderCell"
    }

}
