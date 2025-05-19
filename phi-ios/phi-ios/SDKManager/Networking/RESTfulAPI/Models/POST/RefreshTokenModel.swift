//
//  RefreshTokenModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/3.
//

import Foundation

struct RefreshTokenModel {
    let refreshToken: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["refreshToken"].string = refreshToken
        
        return json
    }
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
