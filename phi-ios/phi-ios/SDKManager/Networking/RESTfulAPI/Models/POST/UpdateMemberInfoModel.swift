//
//  UpdateMemberInfoModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/20.
//

import Foundation

/*
  "name": "王小明",
  "email": "t1@xxx.com",
  "gender": "M"
*/

struct UpdateMemberInfoModel {
    let name: String
    let email: String
    let gender: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["name"].string = name
        json["email"].string = email
        json["gender"].string = gender
        
        return json
    }
    
    init(name: String, email: String, gender: String) {
        self.name = name
        self.email = email
        self.gender = gender
    }
}
