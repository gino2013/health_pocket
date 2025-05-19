//
//  MemberRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/7.
//

import Foundation

/*
 "returnCode": "0001",
 "returnDesc": "資料格式不正確",
 "returnData": {
     "memberAccount": "string",
     "officialNumber": "string",
     "birthDate": "string",
     "email": "string",
     "name": "string",
     "gender": "string"
 }
 */

class MemberRspModel: JSONDecodable {
    public var memberAccount: String
    public var officialNumber: String
    public var birthDate: String
    public var email: String
    public var name: String
    public var gender: String
    
    required init(json: JSON) {
        memberAccount = json["memberAccount"].stringValue
        officialNumber = json["officialNumber"].stringValue
        birthDate = json["birthDate"].stringValue
        email = json["email"].stringValue
        name = json["name"].stringValue
        gender = json["gender"].stringValue
    }
}
