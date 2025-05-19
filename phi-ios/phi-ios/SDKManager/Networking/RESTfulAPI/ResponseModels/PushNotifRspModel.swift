//
//  PushNotifRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/17.
//

import Foundation

/*
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
 */

class PushNotifRspModel: JSONDecodable {
    var pushNotificationId: Int
    var pushNotificationType: String
    var title: String
    var subTitle: String
    var content: String
    var createTime: String
    var parameters: NotifParameterRspModel
    var isRead: Bool
    
    required init(json: JSON) {
        pushNotificationId = json["pushNotificationId"].intValue
        pushNotificationType = json["pushNotificationType"].stringValue
        title = json["title"].stringValue
        subTitle = json["subTitle"].stringValue
        content = json["content"].stringValue
        createTime = json["createTime"].stringValue
        
        let parametersObj = json["parameters"]
        parameters = NotifParameterRspModel(json: parametersObj)
        
        isRead = json["isRead"].boolValue
    }
}
