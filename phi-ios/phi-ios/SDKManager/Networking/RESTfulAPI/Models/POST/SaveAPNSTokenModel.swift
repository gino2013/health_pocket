//
//  SaveAPNSTokenModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/3.
//

import Foundation

struct SaveAPNSTokenModel {
    let pushNotificationToken: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["pushNotificationToken"].string = pushNotificationToken
        
        return json
    }
    
    init(pushNotificationToken: String) {
        self.pushNotificationToken = pushNotificationToken
    }
}
