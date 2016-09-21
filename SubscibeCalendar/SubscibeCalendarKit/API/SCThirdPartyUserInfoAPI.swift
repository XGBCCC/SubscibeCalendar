//
//  SCThirdPartyUserInfoAPI.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/20.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON


let SCThirdPartyUserInfoEndpointClosure = {(target:SCThirdPartyUserInfoAPI) -> Endpoint<SCThirdPartyUserInfoAPI> in
    let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
    let endpoint = Endpoint<SCThirdPartyUserInfoAPI>(URL: url, sampleResponseClosure:{.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters,parameterEncoding:.URL)
    return endpoint
}
let SCThirdPartyUserInfoAPIProvider = MoyaProvider<SCThirdPartyUserInfoAPI>(endpointClosure: SCThirdPartyUserInfoEndpointClosure,plugins: [NetworkLoggerPlugin(verbose: true, output: DDPrint,responseDataFormatter: JSONResponseDataFormatter)])

public enum SCThirdPartyUserInfoAPI{
    case Weibo(String,String)
    case WeChat(String,String,String)
    case QQ(String,String,String)
}

extension SCThirdPartyUserInfoAPI:TargetType{
    public var baseURL:NSURL {
        switch self {
        case .Weibo(_, _):
            return NSURL(string:"https://api.weibo.com/2/users")!
        default:
            return NSURL(string:"https://api.weibo.com/2/eps/user/info.json")!
        }
    }
    public var path:String{
        switch self {
        case .Weibo(_, _):
            return "/show.json"
        default:
            return ""
        }
    }
    
    public var method:Moya.Method{
        return .GET
    }
    
    public var parameters:[String:AnyObject]? {
        switch self {
        case .Weibo(let accessToken, let uid):
            return ["source":SCThirdPartyKeys.Weibo.appID,"access_token":accessToken,"uid":uid]
        default:
            return nil
        }
    }
    
    public var multipartBody:[Moya.MultipartFormData]? {
        return nil
    }
    
    //样本数据，用来进行testing
    public var sampleData: NSData {
        return "NO Data".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}