//
//  ReminderTimeGroupRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

class ReminderTimeGroupRspModel: JSONDecodable {
    var timeTitle: String
    var items: [ReminderRspModel]
    
    required init(json: JSON) {
        timeTitle = json["timeTitle"].stringValue
        items = json["items"].arrayValue.map { ReminderRspModel(json: $0) }
    }
    
    // array
    /*
    var reminderTimeGroup: [(time: String, records: [ReminderRspModel])] = []
    
    required init(json: JSON) {
        for (time, recordJsonArray) in json {
            var records: [ReminderRspModel] = []
            for recordJson in recordJsonArray.arrayValue {
                let record = ReminderRspModel(json: recordJson)
                records.append(record)
            }
            reminderTimeGroup.append((time: time, records: records))
        }
    }
    */
    
    // dictionary
    /*
    var reminderTimeGroup: [ String: [ReminderRspModel] ] = [:]
    
    required init(json: JSON) {
        for (time, recordJsonArray) in json {
            var records: [ReminderRspModel] = []
            for recordJson in recordJsonArray.arrayValue {
                let record = ReminderRspModel(json: recordJson)
                records.append(record)
            }
            reminderTimeGroup[time] = records
        }
    }
    */
}
