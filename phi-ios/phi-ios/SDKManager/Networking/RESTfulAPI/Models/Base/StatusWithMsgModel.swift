//
//  StatusWithMsgModel.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

class StatusWithMsgModel: JSONDecodable {
    var message: String
    var status: Bool
    var errorCode: String

    required init(json: JSON) {
        status = json["status"].boolValue

        if json["errorCode"].exists() {
            errorCode = json["errorCode"].stringValue
        } else {
            errorCode = ""
        }
        
        if json["message"].exists() {
            message = json["message"].stringValue
        } else {
            message = ""
        }
    }
}
