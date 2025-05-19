//
//  GetJwtTokenModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/9/19.
//

import Foundation

struct GetJwtTokenModel {
    let memberAccount: String
    let memberKeycode: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["userName"].string = memberAccount
        json["password"].string = memberKeycode
        
        return json
    }
    
    init(memberAccount: String, memberKeycode: String) {
        self.memberAccount = memberAccount
        self.memberKeycode = memberKeycode
    }
}
