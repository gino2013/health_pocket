//
//  UpdateMemberKeyCodeModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/3.
//

import Foundation

struct UpdateMemberKeyCodeModel {
    let oldMemberKeycode: String
    let newMemberKeycode: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["oldMemberKeycode"].string = oldMemberKeycode
        json["newMemberKeycode"].string = newMemberKeycode
        
        return json
    }
    
    init(oldMemberKeycode: String, newMemberKeycode: String) {
        self.oldMemberKeycode = oldMemberKeycode
        self.newMemberKeycode = newMemberKeycode
    }
}
