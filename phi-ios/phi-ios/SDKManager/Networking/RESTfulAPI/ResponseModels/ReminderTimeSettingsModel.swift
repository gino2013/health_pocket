//
//  ReminderTimeSettingsModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

/*
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
*/

class TimeSettingItem: JSONDecodable {
    var id: Int
    var remindTime: String
    
    required init(json: JSON) {
        id = json["id"].intValue
        remindTime = json["remindTime"].stringValue
    }
}

class ReminderTimeSettingsModel: JSONDecodable {
    var dataArray: Array<TimeSettingItem>? = nil
    
    required init(json: JSON) {
        let dataList = json
        var timeSettingList = [TimeSettingItem]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let item = TimeSettingItem(json: item)
                timeSettingList.append(item)
            }
        }

        dataArray = timeSettingList
    }
}
