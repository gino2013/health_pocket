//
//  LoginRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/4/30.
//

import Foundation

class LoginRspModel: JSONDecodable {
    public var idToken: String
    public var refreshToken: String
    public var durationInSecond: Int
    public var isSameUuid: Bool
    public var isMedicalAuthorized: Bool
    
    required init(json: JSON) {
        idToken = json["idToken"].stringValue
        refreshToken = json["refreshToken"].stringValue
        durationInSecond = json["durationInSecond"].intValue
        isSameUuid = json["isSameUuid"].boolValue
        isMedicalAuthorized = json["isMedicalAuthorized"].boolValue
    }
}
