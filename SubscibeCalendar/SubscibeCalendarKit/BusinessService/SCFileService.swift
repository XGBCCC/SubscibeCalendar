//
//  SCFileService.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/7/7.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import CocoaLumberjackSwift
import Alamofire

public class SCFileService {
    
    public class func UploadLogFile(completion:SCCompletionHandler){
        
        var didSendUploaded = false
        
        //设置上传后的文件名
        let timeStr = NSDate.StringWithDate(NSDate(), dateFormat: "yyyy-MM-dd_HH:mm:ss")
        let userObjectId = Defaults[.userObjectId]
        let fileName = "\(userObjectId)_\(timeStr).zip"
        
        //创建临时文件
        if let logZipPath = SCFileOperation.CreateLogZipFile() {
            
            //如果有数据
            if let _ = NSData.init(contentsOfFile: logZipPath) {
                
                didSendUploaded = true
                
                let headers = ["X-LC-Id":SCThirdPartyKeys.LeanCloud.XLCId,"X-LC-Key":SCThirdPartyKeys.LeanCloud.XLCKey,"X-LC-Session":Defaults[.userSessionToken]]
                
                Alamofire.upload(.POST, "https://api.leancloud.cn/1.1/files/\(fileName)", headers: headers,file: NSURL.fileURLWithPath(logZipPath))
                    .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in

                        
                    }
                    .validate()
                    .responseJSON { response in
                        if response.result.isSuccess{
                            completion(result: .Success(nil))
                        }else{
                            completion(result: .Failure(response.result.error!))
                        }
                        
                        //删除临时文件
                        SCFileOperation.DeleteFilePath(logZipPath)
                }
            }
        }
        
        if !didSendUploaded {
            DDLogError("未找到Log日志文件，或者压缩失败")
        }
        
        
    }
    
}