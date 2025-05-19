//
//  CheckMembershipRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/2.
//

import Foundation

class CheckMembershipRspModel: JSONDecodable {
    public var isMember: Bool
    
    required init(json: JSON) {
        isMember = json["isMember"].boolValue
    }
}
