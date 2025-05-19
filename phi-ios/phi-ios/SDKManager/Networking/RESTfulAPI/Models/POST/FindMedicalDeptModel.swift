//
//  FindMedicalDeptModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/9.
//

import Foundation

struct FindMedicalDeptModel {
    let partnerId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["partnerId"].int = partnerId
        
        return json
    }
    
    init(partnerId: Int) {
        self.partnerId = partnerId
    }
}
