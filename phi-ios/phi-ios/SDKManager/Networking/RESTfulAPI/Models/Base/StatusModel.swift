//
//  StatusModel.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

class StatusModel: JSONDecodable {
    var error: String
    var status: Bool

    required init(json: JSON) {
        status = json["status"].boolValue

        if json["error"].exists() {
            error = json["error"].stringValue
        } else {
            error = ""
        }
    }
}
