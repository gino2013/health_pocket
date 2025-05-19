//
//  JwtTokenRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/19.
//

import Foundation

class JwtTokenRspModel: JSONDecodable {
    public var type: String
    public var token: String
    public var userName: String
    
    required init(json: JSON) {
        type = json["type"].stringValue
        token = json["token"].stringValue
        userName = json["userName"].stringValue
    }
}
