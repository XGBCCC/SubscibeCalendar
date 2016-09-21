//
//  SCUserDefaults.swift
//  SubscibeCalendar
//
//  Created by JimBo on 16/6/21.
//  Copyright © 2016年 JimBo. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private let userObjectIdKey = "userObjectId"
private let screenNameKey = "screen_name"
private let avatarURLStringKey = "avatar_large"
private let userSessionTokenKey = "userSessionToken"

public extension DefaultsKeys{
    static let userObjectId = DefaultsKey<String>(userObjectIdKey)
    static let screen_name = DefaultsKey<String>(screenNameKey)
    static let avatarURLString = DefaultsKey<String>(avatarURLStringKey)
    static let userSessionToken = DefaultsKey<String>(userSessionTokenKey)
}
