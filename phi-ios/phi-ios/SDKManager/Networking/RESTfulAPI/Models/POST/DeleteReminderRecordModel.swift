//
//  DeleteReminderRecordModel.swift
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
   "reminderRecordMedicineInfoId": 10
 }
*/

struct DeleteReminderRecordModel {
    let remindDate: String
    let reminderSettingId: Int
    let reminderTimeSettingId: Int
    let reminderSingleTimeSettingId: Int
    let reminderRecordMedicineInfoId: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["remindDate"].string = remindDate
        json["reminderSettingId"].int = reminderSettingId
        json["reminderTimeSettingId"].int = reminderTimeSettingId
        if reminderSingleTimeSettingId != 0 {
            json["reminderSingleTimeSettingId"].int = reminderSingleTimeSettingId
        }
        json["reminderRecordMedicineInfoId"].int = reminderRecordMedicineInfoId
        return json
    }
    
    init(remindDate: String, reminderSettingId: Int, reminderTimeSettingId: Int, reminderSingleTimeSettingId: Int, reminderRecordMedicineInfoId: Int) {
        self.remindDate = remindDate
        self.reminderSettingId = reminderSettingId
        self.reminderTimeSettingId = reminderTimeSettingId
        self.reminderSingleTimeSettingId = reminderSingleTimeSettingId
        self.reminderRecordMedicineInfoId = reminderRecordMedicineInfoId
    }
}
