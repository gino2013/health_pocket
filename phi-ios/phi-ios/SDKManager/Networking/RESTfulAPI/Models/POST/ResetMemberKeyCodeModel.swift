//
//  ResetMemberKeyCodeModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/30.
//

import Foundation

struct ResetMemberKeyCodeModel {
    let memberAccount: String
    let memberKeycode: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["memberAccount"].string = memberAccount
        json["memberKeycode"].string = memberKeycode
        
        return json
    }
    
    init(memberAccount: String, memberKeycode: String) {
        self.memberAccount = memberAccount
        self.memberKeycode = memberKeycode
    }
}
