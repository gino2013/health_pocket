//
//  MarkNotificationModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/17.
//

import Foundation

struct MarkNotificationModel {
    let pushNotificationId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["pushNotificationId"].int = pushNotificationId
        
        return json
    }
    
    init(pushNotificationId: Int) {
        self.pushNotificationId = pushNotificationId
    }
}
