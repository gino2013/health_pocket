//
//  MedicalDeptRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/9.
//

import Foundation

class MedicalDeptRspModel: JSONDecodable {
    var code: String
    var name: String
    var hasAuthorized: Bool

    required init(json: JSON) {
        code = json["code"].stringValue
        name = json["name"].stringValue
        hasAuthorized = json["hasAuthorized"].boolValue
    }
}
