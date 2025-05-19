//
//  BatchLoginRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/4/29.
//

import Foundation

class BatchLoginRspModel: JSONDecodable {
    public var idToken: String
    public var durationInSecond: Int
    
    required init(json: JSON) {
        idToken = json["idToken"].stringValue
        durationInSecond = json["durationInSecond"].intValue
    }
}
