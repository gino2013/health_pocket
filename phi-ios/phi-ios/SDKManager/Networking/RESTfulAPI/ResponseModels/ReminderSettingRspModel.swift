//
//  ReminderSettingRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

/*
resp
{
    "returnCode": "0000",
    "returnDesc": "執行成功",
    "returnData": {
        "reminderSettingId": 12,
        "type": "MEDICINE",
        "startDate": "2024/07/19",
        "endDate": "2024/08/23",
        "reminderTimeSettings": [
            {
                "id": 65,
                "remindTime": "12:00:00"
            },
            {
                "id": 64,
                "remindTime": "10:00:00"
            }
        ],
        "frequencyType": "DAILY",
        "frequencyWeekdays": [],
        "frequencyDays": null,
        "isEnded": false,
        "reminderSettingMedicineInfo": {
            "medicineName": "降血壓藥",
            "medicineNameAlias": "降血壓",
            "dose": 1.0,
            "doseUnits": "顆",
            "useTime": "PC"
        }
    }
}
*/

class ReminderSettingRspModel: JSONDecodable {
    var reminderSettingId: Int
    var type: String
    var startDate: String
    var endDate: String
    var reminderTimeSettings: ReminderTimeSettingsModel
    var frequencyType: String
    var frequencyWeekdays: Array<Int>
    var frequencyDays: Int
    var isEnded: Bool
    var reminderSettingMedicineInfo: ReminderMedicineInfoModel
    
    required init(json: JSON) {
        reminderSettingId = json["reminderSettingId"].intValue
        type = json["type"].stringValue
        startDate = json["startDate"].stringValue
        endDate = json["endDate"].stringValue
        
        let timeSettingObjs = json["reminderTimeSettings"]
        reminderTimeSettings = ReminderTimeSettingsModel(json: timeSettingObjs)
        
        frequencyType = json["frequencyType"].stringValue
        
        var dayArray = [Int]()
        for (_, dayObj): (String, JSON) in json["frequencyWeekdays"] {
            dayArray.append(dayObj.intValue)
        }
        frequencyWeekdays = dayArray
        frequencyDays = json["frequencyDays"].intValue
        isEnded = json["isEnded"].boolValue
        
        let settingObj = json["reminderSettingMedicineInfo"]
        reminderSettingMedicineInfo = ReminderMedicineInfoModel(json: settingObj)
    }
}
