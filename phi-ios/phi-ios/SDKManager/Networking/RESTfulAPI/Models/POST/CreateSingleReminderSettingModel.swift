//
//  CreateSingleReminderSettingModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/29.
//

import Foundation

/*
req
{
  isRemoved = true 是刪除
  儲存是false
 
  "originalRemindDate": "2024/07/28", 原來時間
  "remindDate": "2024/08/25", 設定本次日期
  "remindTime": "10:10:00",
  "reminderSettingId": 12,
  "reminderTimeSettingId": 70
}
*/

struct CreateSingleReminderSettingModel {
    var isRemoved: Bool
    let originalRemindDate: String
    let remindDate: String
    let remindTime: String
    let reminderSettingId: Int
    let reminderTimeSettingId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["isRemoved"].bool = isRemoved
        json["originalRemindDate"].string = originalRemindDate
        json["remindDate"].string = remindDate
        json["remindTime"].string = remindTime
        json["reminderSettingId"].int = reminderSettingId
        json["reminderTimeSettingId"].int = reminderTimeSettingId
        return json
    }
    
    init(isRemoved: Bool, originalRemindDate: String, remindDate: String, remindTime: String, reminderSettingId: Int, reminderTimeSettingId: Int) {
        self.isRemoved = isRemoved
        self.originalRemindDate = originalRemindDate
        self.remindDate = remindDate
        self.remindTime = remindTime
        self.reminderSettingId = reminderSettingId
        self.reminderTimeSettingId = reminderTimeSettingId
    }
}
