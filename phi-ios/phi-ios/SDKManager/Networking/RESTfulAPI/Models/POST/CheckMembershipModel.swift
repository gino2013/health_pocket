//
//  CheckMembershipModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/2.
//

import Foundation

struct CheckMembershipModel {
    let memberAccount: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["memberAccount"].string = memberAccount
        
        return json
    }
    
    init(memberAccount: String) {
        self.memberAccount = memberAccount
    }
}
