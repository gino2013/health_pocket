//
//  GetReminderRecordsModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/29.
//

import Foundation

/*
req
{
  "startDate": "2024/09/19",
  "endDate": "2024/09/29"
}
*/

struct GetReminderRecordsModel {
    let startDate: String
    let endDate: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["startDate"].string = startDate
        json["endDate"].string = endDate
        
        return json
    }
    
    init(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
