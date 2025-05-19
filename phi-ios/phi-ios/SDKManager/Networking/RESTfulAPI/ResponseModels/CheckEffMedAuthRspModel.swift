//
//  CheckEffMedAuthRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/18.
//

import Foundation

class CheckEffMedAuthRspModel: JSONDecodable {
    public var effectiveMedicalAuth: Bool
    
    required init(json: JSON) {
        effectiveMedicalAuth = json["effectiveMedicalAuth"].boolValue
    }
}
