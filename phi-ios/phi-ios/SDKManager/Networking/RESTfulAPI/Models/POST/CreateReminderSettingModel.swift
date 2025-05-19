//
//  CreateReminderSettingModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/29.
//

import Foundation

/*
  {
    "startDate": "2024/07/26",                // 提醒開始時間
    "endDate": "2024/08/17",                // 結束時間
    "frequencyType": "DAILY",                // 頻率類型: DAILY-每日 WEEKLY-每週 DAY_PERIOD-每次間隔幾日
    "remindTimes": ["09:00:00","12:00:00"],        // 提醒時間
    "type": "MEDICINE",                    // 目前只有用藥提醒 MEDICINE
    "frequencyWeekdays": [                // 1-星期一、....、7-星期日 (頻率為每週時必填)
      "7",
      "1"
    ],
    "frequencyDays": 1,                    // 頻率為每次間隔幾日時必填
    "medicineInfo": {
      "dose": 1,
      "doseUnits": "顆",
      "medicineName": "抗敏寧",
      "useTime": "PC",                    // AC("飯前"), PC("飯後"), HS("睡前"), PCHS("飯後、睡前"), ACHS("飯前、睡前"), OTHER("其他時段");
      "medicineNameAlias": "過敏藥"            // 別名
    }
  },
  {
    "startDate": "2024/07/26",
    "endDate": "2024/08/17",
    "frequencyType": "DAILY",
    "remindTimes": ["09:00:00","09:00:00"],
    "type": "MEDICINE",
    "frequencyWeekdays": [
      "5",
      "4"
    ],
    "frequencyDays": 1,
    "medicineInfo": {
      "dose": 1,
      "doseUnits": "顆",
      "medicineName": "抗敏寧",
      "useTime": "PC",
      "medicineNameAlias": "過敏藥"
    }
  }
*/

class MedicineInfo {
    var dose: Int
    var doseUnits: String
    var medicineName: String
    var useTime: String
    var medicineNameAlias: String

    init(dose: Int, doseUnits: String, medicineName: String, useTime: String, medicineNameAlias: String) {
        self.dose = dose
        self.doseUnits = doseUnits
        self.medicineName = medicineName
        self.useTime = useTime
        self.medicineNameAlias = medicineNameAlias
    }

    func toJSON() -> [String: Any] {
        return [
            "dose": dose,
            "doseUnits": doseUnits,
            "medicineName": medicineName,
            "useTime": useTime,
            "medicineNameAlias": medicineNameAlias
        ]
    }
}

class ReminderSetting {
    var startDate: String
    var endDate: String
    var frequencyType: String
    var remindTimes: [String]  // 提醒時間 ["09:00:00","12:00:00"]
    var type: String
    var frequencyWeekdays: [String] /* 1-星期一、....、7-星期日 (頻率為每週時必填) */
    var frequencyDays: Int  /* 頻率為每次間隔幾日時必填 */
    var medicineInfo: MedicineInfo

    init(startDate: String, endDate: String, frequencyType: String, remindTimes: [String], type: String, frequencyWeekdays: [String], frequencyDays: Int, medicineInfo: MedicineInfo) {
        self.startDate = startDate
        self.endDate = endDate
        self.frequencyType = frequencyType
        self.remindTimes = remindTimes
        self.type = type
        self.frequencyWeekdays = frequencyWeekdays
        self.frequencyDays = frequencyDays
        self.medicineInfo = medicineInfo
    }

    func toJSON() -> [String: Any] {
        return [
            "startDate": startDate,
            "endDate": endDate,
            "frequencyType": frequencyType,
            "remindTimes": remindTimes,
            "type": type,
            "frequencyWeekdays": frequencyWeekdays,
            "frequencyDays": frequencyDays,
            "medicineInfo": medicineInfo.toJSON()
        ]
    }
}

class CreateReminderSettingModel {
    var reminders: [ReminderSetting]

    init(reminders: [ReminderSetting]) {
        self.reminders = reminders
    }

    func toJSON() -> [[String: Any]] {
        return reminders.map { $0.toJSON() }
    }
    
    func toNSDictionaryArray() -> [NSDictionary] {
        return reminders.map { $0.toJSON() as NSDictionary }
    }
}
