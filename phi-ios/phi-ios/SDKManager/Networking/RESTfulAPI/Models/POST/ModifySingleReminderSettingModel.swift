//
//  ModifySingleReminderSettingModel.swift
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
 
  "remindDate": "2024/08/17",
  "remindTime": "09:10:00",
  "reminderSettingId": 12,
  "reminderTimeSettingId": 70,
 
  假設已經新建過才會有這個ID,就呼叫編輯單次API。假設沒有這個ID,就要呼叫新建一筆單次API.
  "reminderSingleTimeSettingId": 13
}
*/

struct ModifySingleReminderSettingModel {
    let isRemoved: Bool
    let remindDate: String
    let remindTime: String
    let reminderSettingId: Int
    let reminderTimeSettingId: Int
    let reminderSingleTimeSettingId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["isRemoved"].bool = isRemoved
        json["remindDate"].string = remindDate
        json["remindTime"].string = remindTime
        json["reminderSettingId"].int = reminderSettingId
        json["reminderTimeSettingId"].int = reminderTimeSettingId
        json["reminderSingleTimeSettingId"].int = reminderSingleTimeSettingId
        return json
    }
    
    init(isRemoved: Bool, remindDate: String, remindTime: String, reminderSettingId: Int, reminderTimeSettingId: Int, reminderSingleTimeSettingId: Int) {
        self.isRemoved = isRemoved
        self.remindDate = remindDate
        self.remindTime = remindTime
        self.reminderSettingId = reminderSettingId
        self.reminderTimeSettingId = reminderTimeSettingId
        self.reminderSingleTimeSettingId = reminderSingleTimeSettingId
    }
}
