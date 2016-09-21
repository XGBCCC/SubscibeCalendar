//
//  SCFileOperation.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/7/7.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import ZipArchive

public class SCFileOperation{
    class func CreateLogZipFile() -> String? {
        
        DeleteFilePath(LogZipFilePath())
        
        let fileManager = NSFileManager.defaultManager()
        //获取Documents目录
        //    let documentFileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains:.UserDomainMask).first
        //获取Library目录
        let libraryFileURL = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first
        
        if let libraryFilePath = libraryFileURL?.path{
            let logPath = libraryFilePath + "/Caches/Logs"
            if fileManager.fileExistsAtPath(logPath) {
                let zipPath = LogZipFilePath()
                let success = SSZipArchive.createZipFileAtPath(zipPath, withContentsOfDirectory: logPath)
                if success {
                    return zipPath
                }
            }
        }
        return nil
    }
    
    class func LogZipFilePath() -> String {
        let libraryFileURL = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first
        let zipPath = (libraryFileURL?.path)!+"/Caches/Logs.zip"
        return zipPath
    }
    
    class func DeleteFilePath(filePath:String){
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtPath(filePath)
        }catch{
        
        }
        
    }
}
