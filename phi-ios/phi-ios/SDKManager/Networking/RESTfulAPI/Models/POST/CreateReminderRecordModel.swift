//
//  CreateReminderRecordModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/29.
//

import Foundation

/*
 req
 {
   "remindDate": "2024/07/19",
   "reminderSettingId": 12,
   "reminderTimeSettingId": 30,
   "reminderSingleTimeSettingId": null,
   "takenTime": "2024/07/19 10:30:09"
 }
*/

struct CreateReminderRecordModel {
    let remindDate: String
    let reminderSettingId: Int
    let reminderTimeSettingId: Int
    let reminderSingleTimeSettingId: Int
    let takenTime: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["remindDate"].string = remindDate
        json["reminderSettingId"].int = reminderSettingId
        json["reminderTimeSettingId"].int = reminderTimeSettingId
        if reminderSingleTimeSettingId != 0 {
            json["reminderSingleTimeSettingId"].int = reminderSingleTimeSettingId
        }
        json["takenTime"].string = takenTime
        return json
    }
    
    init(remindDate: String, reminderSettingId: Int, reminderTimeSettingId: Int, reminderSingleTimeSettingId: Int, takenTime: String) {
        self.remindDate = remindDate
        self.reminderSettingId = reminderSettingId
        self.reminderTimeSettingId = reminderTimeSettingId
        self.reminderSingleTimeSettingId = reminderSingleTimeSettingId
        self.takenTime = takenTime
    }
}
