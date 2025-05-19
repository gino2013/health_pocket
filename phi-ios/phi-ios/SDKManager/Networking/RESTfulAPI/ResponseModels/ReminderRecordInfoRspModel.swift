//
//  ReminderRecordInfoRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/30.
//

import Foundation

/*
 "reminderSettingId": 12,
 "reminderTimeSettingId": 30,
 "reminderSingleTimeSettingId": null,
 "reminderRecordMedicineInfoId": 10
 */

class ReminderRecordInfoRspModel: JSONDecodable {
    public var reminderSettingId: Int
    public var reminderTimeSettingId: Int
    public var reminderSingleTimeSettingId: Int
    public var reminderRecordMedicineInfoId: Int
    
    required init(json: JSON) {
        reminderSettingId = json["reminderSettingId"].intValue
        reminderTimeSettingId = json["reminderTimeSettingId"].intValue
        reminderSingleTimeSettingId = json["reminderSingleTimeSettingId"].intValue
        reminderRecordMedicineInfoId = json["reminderRecordMedicineInfoId"].intValue
    }
}
