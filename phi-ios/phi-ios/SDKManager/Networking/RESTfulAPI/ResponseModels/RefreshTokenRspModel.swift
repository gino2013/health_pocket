//
//  RefreshTokenRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/3.
//

import Foundation

class RefreshTokenRspModel: JSONDecodable {
    public var idToken: String
    public var refreshToken: String
    public var durationInSecond: Int
    
    required init(json: JSON) {
        idToken = json["idToken"].stringValue
        refreshToken = json["refreshToken"].stringValue
        durationInSecond = json["durationInSecond"].intValue
    }
}
