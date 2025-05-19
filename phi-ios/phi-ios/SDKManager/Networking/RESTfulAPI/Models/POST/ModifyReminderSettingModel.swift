//
//  ModifyReminderSettingModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

/*
req
{
  "reminderSettingId": 12,
  "startDate": "2024/07/26",                // 開始日期(過去不能修改，所以是當日或未來)，如果已經開始的提醒 開始日期不會異動，還沒開始的可以異動開始日期
  "endDate": "2024/09/03",
  "frequencyType": "DAILY",
  "reminderTimeSettings": [
    {
      "id": 29,
      "remindTime": "10:00:00"
    },
    {
      "id": 30,
      "remindTime": "12:00:00"
    }
  ],
  "type": "MEDICINE",
  "frequencyWeekdays": [
  ],
  "frequencyDays": null
}
*/

class TimeSettingBasicModel {
    var id: Int
    var remindTime: String
    
    init(id: Int, remindTime: String) {
        self.id = id
        self.remindTime = remindTime
    }
    
    func toJSON() -> [String: Any] {
        return [
            "id": id,
            "remindTime": remindTime
        ]
    }
}

class ModifyReminderSettingModel {
    var reminderSettingId: Int
    var startDate: String
    var endDate: String
    var frequencyType: String
    var reminderTimeSettings: [TimeSettingBasicModel]
    var type: String
    var frequencyWeekdays: Array<String>
    var frequencyDays: Int
    
    init(reminderSettingId: Int, startDate: String, endDate: String, frequencyType: String, reminderTimeSettings: [TimeSettingBasicModel], type: String, frequencyWeekdays: Array<String>, frequencyDays: Int) {
        self.reminderSettingId = reminderSettingId
        self.startDate = startDate
        self.endDate = endDate
        self.frequencyType = frequencyType
        self.reminderTimeSettings = reminderTimeSettings
        self.type = type
        self.frequencyWeekdays = frequencyWeekdays
        self.frequencyDays = frequencyDays
    }
    
    func toJSON() -> [String: Any] {
        return [
            "reminderSettingId": reminderSettingId,
            "startDate": startDate,
            "endDate": endDate,
            "frequencyType": frequencyType,
            "reminderTimeSettings": reminderTimeSettings.map { $0.toJSON() },
            "type": type,
            "frequencyWeekdays": frequencyWeekdays,
            "frequencyDays": frequencyDays
        ]
    }
}
