//
//  RegisterModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/25.
//

import Foundation

class RegisterModel {
    var mobileUuid: String
    // 帳號
    var memberAccount: String
    // var mobilePhone: String = ""
    // 真實名字 optional
    // var memberName: String = ""
    // 修飾
    var memberKeycode: String
    // 修飾
    var officialNumber: String
    // Format is yyyy-MM-dd
    var birthDate: String
    // optional
    var email: String
    // 是否OTP驗證成功
    var hasBindingTOTP: Bool
    
    func toJSON() -> JSON {
        var json = JSON()
        json["mobileUuid"].string = mobileUuid
        json["memberAccount"].string = memberAccount
        //json["mobilePhone"].string = mobilePhone
        //json["memberName"].string = memberName
        json["memberKeycode"].string = memberKeycode
        json["officialNumber"].string = officialNumber
        json["birthDate"].string = birthDate
        json["email"].string = email
        json["hasBindingTOTP"].bool = hasBindingTOTP
        
        return json
    }
    
    init(mobileUuid: String, memberAccount: String, memberKeycode: String, officialNumber: String, birthDate: String, email: String, hasBindingTOTP: Bool) {
        self.mobileUuid = mobileUuid
        self.memberAccount = memberAccount
        //self.mobilePhone = mobilePhone
        //self.memberName = memberName
        self.memberKeycode = memberKeycode
        self.officialNumber = officialNumber
        self.birthDate = birthDate
        self.email = email
        self.hasBindingTOTP = hasBindingTOTP
    }
}
