//
//  ModifyReminderSettingRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/30.
//

import Foundation

class ModifyReminderSettingRspModel: JSONDecodable {
    public var reminderSettingId: Int
    
    required init(json: JSON) {
        reminderSettingId = json["reminderSettingId"].intValue
    }
}
