//
//  SCSettingViewController.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/17.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Whisper
import SubscibeCalendarKit
import NVActivityIndicatorView

class SCSettingViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    @IBAction func navCloseButtonClicked(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: - TableView Delegate
extension SCSettingViewController{
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(SCSettingUserCell.CellIdentifier(), forIndexPath: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(SCSettingDefaultCell.CellIdentifier(), forIndexPath: indexPath)
                cell.textLabel?.text = "我的订阅"
                return cell
            }
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(SCSettingDefaultCell.CellIdentifier(), forIndexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                if Defaults.hasKey(.userObjectId) && String(Defaults[.userObjectId]).characters.count > 0 {
                    return
                }
                SCUserService.LoginWithThirdParty(.Weibo) { (result) in
                    switch result {
                    case .Success(_):
                        let murmur = Murmur(title: "登录成功",
                                            backgroundColor: UIColor.SCStatusBarTipBackgroundColor(),
                                            titleColor: UIColor.whiteColor())
                        show(whistle: murmur)
                        tableView.reloadData()
                    case .Failure(_):
                        let murmur = Murmur(title: "登录失败",
                                            backgroundColor: UIColor.SCStatusBarTipBackgroundColor(),
                                            titleColor: UIColor.whiteColor())
                        show(whistle: murmur)
                        
                    }
                    
                }
            }else{
                let subscribedCalendarsVC = SCSubscribedCalendarsViewController()
                self.navigationController?.pushViewController(subscribedCalendarsVC, animated: true)
            }
        }
        
        
        
    }
}

//摇一摇上传日志文件
extension SCSettingViewController: NVActivityIndicatorViewable{

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        self.startActivityAnimating()
        SCFileService.UploadLogFile { (result) in
            self.stopActivityAnimating()
            
            switch result {
            case .Success(_):
                let murmur = Murmur(title: "日志上传成功",
                    backgroundColor: UIColor.SCStatusBarTipBackgroundColor(),
                    titleColor: UIColor.whiteColor())
                show(whistle: murmur)
            case .Failure(_):
                let murmur = Murmur(title: "日志上传失败",
                    backgroundColor: UIColor.SCStatusBarTipBackgroundColor(),
                    titleColor: UIColor.whiteColor())
                show(whistle: murmur)
            }
        }
    }
    
}
