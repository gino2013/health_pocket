//
//  ReminderSettingIdRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

/*
"returnCode": "0000",
"returnDesc": "執行成功",
"returnData": {
    "reminderSettingIds": [
        23,
        24
    ]
}
*/

class ReminderSettingIdRspModel: JSONDecodable {
    var reminderSettingIds: Array<Int>
    
    required init(json: JSON) {
        var idArray = [Int]()
        for (_, idObj): (String, JSON) in json["reminderSettingIds"] {
            idArray.append(idObj.intValue)
        }
        reminderSettingIds = idArray
    }
}
