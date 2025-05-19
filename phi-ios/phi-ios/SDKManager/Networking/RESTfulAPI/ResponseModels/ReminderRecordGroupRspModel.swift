//
//  ReminderRecordGroupRspModel.swift
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

class ReminderRecordGroupRspModel: JSONDecodable {
    var reminderRecords: [(date: String, timeGroups: [ReminderTimeGroupRspModel])] = []
    
    required init(json: JSON) {
        for (date, recordJsonArray) in json["reminderRecordGroups"] {
            var timeGroups: [ReminderTimeGroupRspModel] = []
            for recordJson in recordJsonArray.arrayValue {
                let record = ReminderTimeGroupRspModel(json: recordJson)
                timeGroups.append(record)
            }
            reminderRecords.append((date: date, timeGroups: timeGroups))
        }
    }
    
    // dictionary
    /*
    var reminderRecords: [String: ReminderTimeGroupRspModel] = [:]
    
    required init(json: JSON) {
        for (date, recordJson) in json["reminderRecordGroups"] {
            let record = ReminderTimeGroupRspModel(json: recordJson)
            reminderRecords[date] = record
        }
    }
    */
    
    /*
    var dataArray: Array<ReminderRspModel>? = nil

    required init(json: JSON) {
        let dataList = json
        var reminderList = [ReminderRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let reminderItem = ReminderRspModel(json: item)
                reminderList.append(reminderItem)
            }
        }

        dataArray = reminderList
    }
    */
}
