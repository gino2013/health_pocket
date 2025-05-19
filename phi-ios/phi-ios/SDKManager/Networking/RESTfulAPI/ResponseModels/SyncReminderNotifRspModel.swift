//
//  SyncReminderNotifRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/30.
//

import Foundation

class ReminderNotifParaRspModel: JSONDecodable {
    var reminderDate: String
    var reminderTime: String
    var reminderSettingId: String
    var reminderTimeSettingId: String
    
    required init(json: JSON) {
        reminderDate = json["reminderDate"].stringValue
        reminderTime = json["reminderTime"].stringValue
        reminderSettingId = json["reminderSettingId"].stringValue
        reminderTimeSettingId = json["reminderTimeSettingId"].stringValue
    }
}

class ReminderNotificationModel: JSONDecodable {
    var remindDateTime: String
    var pushNotificationType: String
    var content: String
    var parameters: ReminderNotifParaRspModel
    
    required init(json: JSON) {
        remindDateTime = json["remindDateTime"].stringValue
        pushNotificationType = json["pushNotificationType"].stringValue
        content = json["content"].stringValue
        
        let parametersObj = json["parameters"]
        parameters = ReminderNotifParaRspModel(json: parametersObj)
    }
}

class SyncReminderNotifRspModel: JSONDecodable {
    var dataArray: Array<ReminderNotificationModel>? = nil

    required init(json: JSON) {
        let dataList = json
        var reminderNotifList = [ReminderNotificationModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let reminderNotifItem = ReminderNotificationModel(json: item)
                reminderNotifList.append(reminderNotifItem)
            }
        }

        dataArray = reminderNotifList
    }
}
