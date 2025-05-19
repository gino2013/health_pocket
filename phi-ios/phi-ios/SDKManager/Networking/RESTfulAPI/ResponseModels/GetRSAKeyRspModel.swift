//
//  GetRSAKeyRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/6.
//

import Foundation

class GetRSAKeyRspModel: JSONDecodable {
    public var key: String
    
    required init(json: JSON) {
        key = json["key"].stringValue
    }
}
