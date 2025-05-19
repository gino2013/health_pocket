//
//  VerifyKeycodeRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/11.
//

import Foundation

/*
 "keycodeVerified": true
 */

class VerifyKeycodeRspModel: JSONDecodable {
    var keycodeVerified: Bool
    
    required init(json: JSON) {
        keycodeVerified = json["keycodeVerified"].boolValue
    }
}
