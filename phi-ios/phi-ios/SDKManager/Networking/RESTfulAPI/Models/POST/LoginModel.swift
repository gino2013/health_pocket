//
//  LoginModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/29.
//

import Foundation

struct LoginModel {
    let memberAccount: String
    let memberKeycode: String
    let mobileUuid: String
    
    
    func toJSON() -> JSON {
        var json = JSON()
        json["memberAccount"].string = memberAccount
        json["memberKeycode"].string = memberKeycode
        json["mobileUuid"].string = mobileUuid
        
        return json
    }
    
    init(memberAccount: String, memberKeycode: String, mobileUuid: String) {
        self.memberAccount = memberAccount
        self.memberKeycode = memberKeycode
        self.mobileUuid = mobileUuid
    }
}
