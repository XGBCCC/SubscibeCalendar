//
//  SCCalendarEventTimeCell.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/7/4.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit

class SCCalendarEventTimeCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func CellIdentifier()->String{
        return "SCCalendarEventTimeCell"
    }

}
