//
//  DelReminderSettingIdModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/30.
//

import Foundation

struct DelReminderSettingIdModel {
    let reminderSettingId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["reminderSettingId"].int = reminderSettingId
        
        return json
    }
    
    init(reminderSettingId: Int) {
        self.reminderSettingId = reminderSettingId
    }
}
