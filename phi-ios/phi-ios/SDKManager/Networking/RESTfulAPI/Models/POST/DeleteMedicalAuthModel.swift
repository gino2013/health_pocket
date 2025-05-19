//
//  DeleteMedicalAuthModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/6.
//

import Foundation

struct DeleteMedicalAuthModel {
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
