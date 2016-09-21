//
//  SCAPI.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/20.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import SwiftyUserDefaults



let SCEndpointClosure = {(target:SCAPI) -> Endpoint<SCAPI> in
    let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
    var parameterEncoding = ParameterEncoding.URL
    
    switch target.method{
    case .GET:
        parameterEncoding = ParameterEncoding.URL
    default:
        parameterEncoding = ParameterEncoding.JSON
    }
    
    let endpoint = Endpoint<SCAPI>(URL: url, sampleResponseClosure:{.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters,parameterEncoding:parameterEncoding)
    
    
    var headers = ["X-LC-Id":SCThirdPartyKeys.LeanCloud.XLCId,"X-LC-Key":SCThirdPartyKeys.LeanCloud.XLCKey,"X-LC-Session":Defaults[.userSessionToken]]

    
    return endpoint.endpointByAddingHTTPHeaderFields(headers)
}
let SCAPIProvider = MoyaProvider<SCAPI>(endpointClosure: SCEndpointClosure,plugins: [NetworkLoggerPlugin(verbose: true,output: DDPrint,responseDataFormatter: JSONResponseDataFormatter)])


public enum SCAPI{
    case LoginWithWeibo(String,String,String)
    case LoginWithWeChat(String,String,String)
    case LoginWithQQ(String,String,String)
    /**
     *  设置用户昵称，头像
     *
     *  @param String _user_ObjectId
     *  @param String 昵称
     *  @param String 头像地址URL
     */
    case InsertUserInfo(String,String,String)
    case Categorys
    /**
     *  获取推荐的日历ID
     *
     *  @param Int 第几页【默认每页20】
     *
     */
    case CalendarIdsForRecommend(Int)
    case Calendars([String])
    /**
     *  根据日历ID，获取日历事件列表
     *
     *  @param Int 日历ID
     *
     */
    case CalendarEvents([String])
    /**
     *  订阅日历
     *
     *  @param String user_objectId
     *  @param String 日历ID
     *
     */
    case SubscribeCalendar(String,String)
    /**
     *  取消订阅
     *
     *  @param String userSubscribedId 用户日历订阅的ID
     *
     */
    case unSubscribeCalendar(String)
    /**
     *  获取已订阅的日历
     *
     *  @param String 用户ObjectId
     *
     */
    case SubscribedCalendar(String)
    /**
     *  更新日历订阅数
     *
     *  @param String calendar_objectId
     *  @param String 只支持“+”，“-”，+：表示订阅数+1   -：表示订阅数减1
     *
     */
    case UpdateCalendarSubscibeCount(String,String)
    /**
     *  获取日历数据统计的ID
     *
     *  @param String 日历ID
     *
     */
    case CalendarStatisticsObjectId(String)
    
    
}

extension SCAPI:TargetType{
    public var baseURL:NSURL {return NSURL(string: "https://api.leancloud.cn/1.1")!}
    public var path:String{
        switch self {
        case .LoginWithWeibo(_,_,_),.LoginWithQQ(_,_,_),.LoginWithWeChat(_,_,_):
            return "/users"
        case .InsertUserInfo(_,_,_):
            return "/classes/userinfo"
        case .Categorys:
            return "/classes/category"
        case .CalendarIdsForRecommend(_):
            return "/classes/calendar_recommend"
        case .Calendars(_):
            return "/classes/calendar"
        case .CalendarEvents(_):
            return "/classes/calendar_event"
        case .SubscribeCalendar,.SubscribedCalendar:
            return "/classes/user_subscibe_calendar"
        case .unSubscribeCalendar(let userSubscribedId):
            return "/classes/user_subscibe_calendar/\(userSubscribedId)"
        case .UpdateCalendarSubscibeCount(let objectId, _):
            return "/classes/calendar_statistics/\(objectId)"
        case .CalendarStatisticsObjectId(_):
            return "/classes/calendar_statistics"
        }
    }
    
    public var method:Moya.Method{
        switch self {
        case .Categorys,.CalendarIdsForRecommend,.Calendars,.CalendarEvents,.SubscribedCalendar,.CalendarStatisticsObjectId:
            return .GET
        case .UpdateCalendarSubscibeCount:
            return .PUT
        case .unSubscribeCalendar:
            return .DELETE
        default:
            return .POST
        }
        
    }
    
    public var parameters:[String:AnyObject]? {
        switch self {
        case .LoginWithWeibo(let uid, let access_token, let expiration_in):
            return ["authData":["weibo":["uid":uid,"access_token":access_token,"expiration_in":expiration_in]]];
        case .InsertUserInfo(let user_objectId,let screen_name, let avatar_large):
            return ["user_objectId":user_objectId,"screen_name":screen_name,"avatar_large":avatar_large]
        case .CalendarIdsForRecommend(let page):
            var parameter:Dictionary<String,String> = Dictionary()
            parameter["order"] = "-subscibe_count"
            parameter["limit"] = "20"
            parameter["skip"] = String(20*page)
            return parameter
        case .Calendars(let calendarObjectIds):
            var parameter:Dictionary<String,String> = Dictionary()
            
            var calendarObjectIdsStr = ""
            for index in 0..<calendarObjectIds.count {
                let obejctId = calendarObjectIds[index]
                calendarObjectIdsStr+=("\"\(obejctId)\"")
                if index<calendarObjectIds.count-1 {
                    calendarObjectIdsStr += ("\"")
                }
            }
            parameter["where"] = "{\"objectId\":{\"$in\":[\(calendarObjectIdsStr)]}}"
            parameter["include"]="calendar_statistics"
            return parameter
        case .CalendarEvents(let calendarIds):
            var parameter:Dictionary<String,String> = Dictionary()
            
            var calendarObjectIdsStr = ""
            for index in 0..<calendarIds.count {
                let obejctId = calendarIds[index]
                calendarObjectIdsStr+=("\"\(obejctId)\"")
                if index<calendarIds.count-1 {
                    calendarObjectIdsStr += ("\"")
                }
            }
            
            parameter["where"] = "{\"calendar_objectId\":{\"$in\":[\(calendarObjectIdsStr)]}}"
            parameter["order"] = "calendar_event_startTime"
            return parameter
        case .SubscribeCalendar(let userObjectId,let calendarObjectId):
            return ["calendar_objectId":calendarObjectId,"user_objectId":userObjectId]
        case .SubscribedCalendar(let userObjectId):
            var parameter:Dictionary<String,String> = Dictionary()
            parameter["where"] = "{\"user_objectId\":\"\(userObjectId)\"}"
            return parameter
        case .UpdateCalendarSubscibeCount(_,let operation):
            var op:String;
            if operation == "+" {
                op = "Increment"
            }else{
                op = "Decrement"
            }
            return ["calendar_subscribeCount":["__op":op,"amount":1]]
        case .CalendarStatisticsObjectId(let calendarId):
            var parameter:Dictionary<String,String> = Dictionary()
            parameter["where"] = "{\"calendar_objectId\":\"\(calendarId)\"}"
            return parameter
        default:
            return nil
        }
    }
    
    public var multipartBody:[Moya.MultipartFormData]? {
        return nil
    }
    
    //样本数据，用来单元测试
    public var sampleData: NSData {
        return "NO Data".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}