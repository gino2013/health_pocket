//
//  GetReminderSettingModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/29.
//

import Foundation

/*
 req
 {
   "remindDate": "2024/07/22", // 帶日曆選擇的日期(過去不能修改，所以是當日或未來)
   "reminderSettingId": 12
 }
 */

struct GetReminderSettingModel {
    let remindDate: String
    let reminderSettingId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["remindDate"].string = remindDate
        json["reminderSettingId"].int = reminderSettingId
        return json
    }
    
    init(remindDate: String, reminderSettingId: Int) {
        self.remindDate = remindDate
        self.reminderSettingId = reminderSettingId
    }
}
