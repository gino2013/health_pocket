//
//  ReminderRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

/*
"reminderRecordGroups": {
    "2024/09/19": {
        "09:00": [ReminderRspModel]
        "09:00": [ReminderRspModel]
    }
    "2024/09/20": {
        "09:00": [ReminderRspModel]
        "09:00": [ReminderRspModel]
    }
}
*/

/*
 "09:00": [
     {
         "type": "MEDICINE",        // 提醒類型(目前只有一種: 用藥提醒 MEDICINE)
         "isSingleTimeSetting": true,
         "reminderDate": "2024/09/19",
         "reminderTime": "09:00:00",
         "reminderSettingId": 12,    // 頻率設定id(主要id)
         "reminderTimeSettingId": 29,    // 時間設定id(頻率下多個時間，每個時間會有一個id)
         "reminderSingleTimeSettingId": 9, // 單次設定 id
         "isChecked": false,            // 是否已服用(如果是用藥提醒的話)
         "checkTime": null,            // 服用時間
 "reminderRecordMedicineInfo": {
                                "reminderRecordMedicineInfoId": 3,
                                "takenTime": "2024/08/02 11:14:38"
                            },
         "isEnded": true,
         "title": "降血壓藥",
         "subTitle": "降血壓",
         "tags": [
             "1顆"
         ],
         "reminderSettingMedicineInfo": {
             "medicineName": "降血壓藥",
             "medicineNameAlias": "降血壓",
             "dose": 1.0,
             "doseUnits": "顆",
             "useTime": "PC"
         }
     }
 ]
 */

/*
"reminderRecordMedicineInfo": {
    "reminderRecordMedicineInfoId": 3,
    "takenTime": "2024/08/02 11:14:38"
}
*/

class ReminderRecordMedicineModel: JSONDecodable {
    var reminderRecordMedicineInfoId: Int
    var takenTime: String
    
    required init(json: JSON) {
        reminderRecordMedicineInfoId = json["reminderRecordMedicineInfoId"].intValue
        takenTime = json["takenTime"].stringValue
    }
}

class ReminderRspModel: JSONDecodable {
    var type: String
    var isSingleTimeSetting: Bool
    var reminderDate: String
    var reminderTime: String
    var reminderSettingId: Int
    var reminderTimeSettingId: Int
    var reminderSingleTimeSettingId: Int
    var isChecked: Bool
    var checkTime: String
    var reminderRecordMedicineInfo: ReminderRecordMedicineModel
    var isEnded: Bool
    var title: String
    var subTitle: String
    var tags: Array<String>
    var reminderSettingMedicineInfo: ReminderMedicineInfoModel
    
    required init(json: JSON) {
        type = json["type"].stringValue
        isSingleTimeSetting = json["isSingleTimeSetting"].boolValue
        reminderDate = json["reminderDate"].stringValue
        reminderTime = json["reminderTime"].stringValue
        reminderSettingId = json["reminderSettingId"].intValue
        reminderTimeSettingId = json["reminderTimeSettingId"].intValue
        reminderSingleTimeSettingId = json["reminderSingleTimeSettingId"].intValue
        isChecked = json["isChecked"].boolValue
        checkTime = json["checkTime"].stringValue
        
        let recordObj = json["reminderRecordMedicineInfo"]
        reminderRecordMedicineInfo = ReminderRecordMedicineModel(json: recordObj)
        
        isEnded = json["isEnded"].boolValue
        title = json["title"].stringValue
        subTitle = json["subTitle"].stringValue
        tags = json["tags"].arrayValue.map { $0.stringValue }
        
        let settingObj = json["reminderSettingMedicineInfo"]
        reminderSettingMedicineInfo = ReminderMedicineInfoModel(json: settingObj)
    }
}
