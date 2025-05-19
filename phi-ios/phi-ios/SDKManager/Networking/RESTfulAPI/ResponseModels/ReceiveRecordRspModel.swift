//
//  ReceiveRecordRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/24.
//

import Foundation

/*
 "receiveRecordId": 1, // or null 未領取, 無法進入領藥結果頁面
 "nthReceiveTime": 1,
 "receiveDate": "2024/05/15", // 領藥時間, or null 未領取 前端顯示 ----/--/--
 "receiveStatus": "0", // 0-領取完畢, 1-待領藥, 2-尚未開始
 "receiveStatusDesc": "領取完畢",
 
     {
       "isReceived": false,
       "receiveRecordId": 37505,
       "nthReceiveTime": 2,
       "receiveDate": null,
       "receiveStatus": "2",
       "receiveStatusDesc": "開始領藥",
       "showDesc": "待領藥"
     },
 */

class ReceiveRecordRspModel: JSONDecodable {
    var receiveRecordId: Int
    var nthReceiveTime: Int
    var receiveDate: String
    var receiveStatus: Int
    var receiveStatusDesc: String
    var showDesc: String
    
    required init(json: JSON) {
        receiveRecordId = json["receiveRecordId"].intValue
        nthReceiveTime = json["nthReceiveTime"].intValue
        receiveDate = json["receiveDate"].stringValue
        receiveStatus = json["receiveStatus"].intValue
        receiveStatusDesc = json["receiveStatusDesc"].stringValue
        showDesc = json["showDesc"].stringValue
    }
}
