//
//  ReminderSettingIdInfoRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/30.
//

import Foundation

/*
"reminderSettingId": 12,
"reminderTimeSettingId": 70,
"reminderSingleTimeSettingId": 13
*/

class ReminderSettingIdInfoRspModel: JSONDecodable {
    public var reminderSettingId: Int
    public var reminderTimeSettingId: Int
    public var reminderSingleTimeSettingId: Int
    
    required init(json: JSON) {
        reminderSettingId = json["reminderSettingId"].intValue
        reminderTimeSettingId = json["reminderTimeSettingId"].intValue
        reminderSingleTimeSettingId = json["reminderSingleTimeSettingId"].intValue
    }
}
