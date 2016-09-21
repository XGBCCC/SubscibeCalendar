//
//  SCSettingUserCell.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/17.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults
import SubscibeCalendarKit

class SCSettingUserCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!

    override func awakeFromNib() {
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    
    func setup(){
        if Defaults.hasKey(.userObjectId) && String(Defaults[.userObjectId]).characters.count > 0 {
            avatarImageView.kf_setImageWithURL(NSURL(string: Defaults[.avatarURLString])!, placeholderImage: UIImage(named: "default_avatar"));
            screenNameLabel.text = Defaults[.screen_name]
        }else{
            avatarImageView.image = UIImage(named: "default_avatar")
            screenNameLabel.text = "点击登录"
        }
    }
    
    
    class func CellIdentifier()->String{
        return "SCSettingUserCell"
    }

}
