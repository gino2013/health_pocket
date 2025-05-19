//
//  PHISDK_AllResponseData.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/10/26.
//

import Foundation

class PHISDK_AllResponseData {
    
    static var sharedInstance = PHISDK_AllResponseData()
    init() {}

    var loginStatus: Bool = false
    var appIsLive: Bool = true
    
    //  MARK: - Account
    var userInfo: MemberRspModel?
    
    //  MARK: - Bank
    //  MARK: - promotion
    //  MARK: - Commen
    
    //  cache
    var memberAccountTmp: String = ""
    var olaawordTmp: String = ""
}
