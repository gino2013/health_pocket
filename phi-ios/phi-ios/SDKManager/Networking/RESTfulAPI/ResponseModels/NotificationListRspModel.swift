//
//  NotificationListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/17.
//

import Foundation

/*
"returnData": {
    "totalPages": 3,
    "currentPage": 0,
    "queryTime": "2024/07/16 10:58:55",
    "pushNotifications": [
        {
            "pushNotificationId": 32,
            "pushNotificationType": "RESERVATION_ACCEPT",
            "title": "領藥提醒",
            "subTitle": "OO藥局 已接受你的預約領藥申請",
            "content": "test......",
            "createTime": "2024/07/15",
            "parameters": {
                "tenantId": "string",
                "medicalType": "string",
                "diagnosisNo": "string",
                "prescriptionNo": "string",
                "receiveRecordId": "1"
            },
            "isRead": false
        }
    ]
}
*/

class NotificationListRspModel: JSONDecodable {
    var totalPages: Int
    var currentPage: Int
    var queryTime: String
    var dataArray: Array<PushNotifRspModel>? = nil
    
    required init(json: JSON) {
        totalPages = json["totalPages"].intValue
        currentPage = json["currentPage"].intValue
        queryTime = json["queryTime"].stringValue
        
        let dataList = json["pushNotifications"]
        var pushNotifInfoList = [PushNotifRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let item = PushNotifRspModel(json: item)
                pushNotifInfoList.append(item)
            }
        }

        dataArray = pushNotifInfoList
    }
}
