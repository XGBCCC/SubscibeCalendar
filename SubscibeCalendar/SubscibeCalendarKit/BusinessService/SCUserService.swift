//
//  SCUserService.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/20.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import MonkeyKing
import SwiftyJSON
import SwiftyUserDefaults
import CocoaLumberjackSwift

public class SCUserService {
    
    
    public class func LoginWithThirdParty(OAuthType:MonkeyKing.SupportedPlatform,completion:SCCompletionHandler){
        //获取第三方授权
        MonkeyKing.OAuth(OAuthType) { (OAuthInfo, response, error) in
            
            DDLogInfo("OAuthInfo:\(OAuthInfo)")
            DDLogInfo("response:\(response)")
            DDLogError("error:\(error)")
            
            if let errorInfo = error{
                let error = NSError(domain: errorInfo.domain, code: 0, userInfo: nil)
                completion(result:.Failure(error))
            }else{
                
                var expiration_in = ""
                var accessToken = ""
                var userID = ""
                
                if let OAuthInfoDictionary = OAuthInfo{
                    
                    let OAuthInfoJSON = JSON(OAuthInfoDictionary)
                    //由于这是个Date类型的，但是JSON不支持Date，Set类型，所以，必须使用之前的字典来判断
                    if let expirationDate = OAuthInfoDictionary.objectForKey("expirationDate"){
                        let expirationDate = NSDate.ValidDate(String(expirationDate), dateFormat: "yyyy-MM-dd HH:mm:ss Z")
                        expiration_in = String(format: "%f", Double(expirationDate.timeIntervalSince1970)*1000);
                        accessToken = OAuthInfoJSON["accessToken"].stringValue
                        userID =  OAuthInfoJSON["userID"].stringValue
                    }else{
                        expiration_in = OAuthInfoJSON["expires_in"].stringValue
                        accessToken = OAuthInfoJSON["access_token"].stringValue
                        userID =  OAuthInfoJSON["uid"].stringValue
                    }
                    
                    if expiration_in.characters.count>0 && accessToken.characters.count>0 && userID.characters.count>0 {
                        //前往leanCloud注册用户
                        SCAPIProvider.request(SCAPI.LoginWithWeibo(userID,accessToken,expiration_in), completion: { (result) in
                            
                            switch result{
                            case let .Success(response):
                                let userJSON = JSON(data:response.data)
                                Defaults[.userObjectId] = userJSON["objectId"].stringValue
                                Defaults[.userSessionToken] = userJSON["sessionToken"].stringValue
                                InsertUserInfoWithOAuthType(OAuthType, accessToken: accessToken, userId: userID,completion: completion)
                                break;
                            case let .Failure(error):
                                DDLogError("\(error)")
                                completion(result: .Failure(NSError.ValidError(error)))
                                break;
                            }
                            
                        })
                    }else{
                        DDLogError("三方登录获取授权数据错误")
                        let error = NSError(domain: "三方登录获取授权数据错误", code: 400, userInfo: nil)
                        completion(result: .Failure(error))
                    }
                    
                    
                    
                    
                }
                
                
                
            }
            
        }
    }
    
    public class func InsertUserInfoWithOAuthType(OAuthType:MonkeyKing.SupportedPlatform,accessToken:String,userId:String,completion:SCCompletionHandler){
        //从微博获取用户信息
        SCThirdPartyUserInfoAPIProvider.request(.Weibo(accessToken,userId), completion: { (result) in
            switch result{
            case let .Success(response):
                
                let userInfoJSON = JSON(data: response.data)
                let screen_name = userInfoJSON["screen_name"].stringValue
                let avatar_large = userInfoJSON["avatar_large"].stringValue
                
                Defaults[.screen_name] = screen_name
                Defaults[.avatarURLString] = avatar_large
                
                //添加用户信息
                SCAPIProvider.request(SCAPI.InsertUserInfo(Defaults[.userObjectId],screen_name,avatar_large),completion: { (result) in
                    
                    switch result{
                    case let .Success(response):
                        let json = JSON(data:response.data)
                        DDLogInfo("\(json)")
                        completion(result: .Success(0))
                    case let .Failure(error):
                        DDLogError("\(error)")
                        completion(result: .Failure(NSError.ValidError(error)))
                    }
                    
                })
                break
            case let .Failure(error):
                DDLogError("\(error)")
                completion(result: .Failure(NSError.ValidError(error)))
                break
            }
        })
    }
    
}