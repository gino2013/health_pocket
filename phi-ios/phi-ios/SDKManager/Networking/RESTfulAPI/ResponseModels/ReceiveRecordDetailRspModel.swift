//
//  ReceiveRecordDetailRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/24.
//

import Foundation

/*
 {
     "receiveDate": "2024/05/15", // 領藥時間
     "nextReceiveDate": "2024/06/15", // 下次領藥時間, or "" 沒有下次 前端顯示 ----/--/--

     "pharmacy":{          // 非合作藥局回傳 null
         "id": "string",
         "code": "string",
         "name": "大樹藥局",
         "address": "台北市忠孝東路五段10號2樓",
         "contactPhone": "02-292003991",
         "businessHours": [
             "string"
          ],
          "partner": true
     }
 }
 */

class ReceiveRecordDetailRspModel: JSONDecodable {
    var receiveDate: String
    var nextReceiveDate: String
    var pharmacyInfo: PharmacyRspModel
    
    required init(json: JSON) {
        receiveDate = json["receiveDate"].stringValue
        nextReceiveDate = json["nextReceiveDate"].stringValue
        
        let pharmacyObj = json["pharmacy"]
        pharmacyInfo = PharmacyRspModel(json: pharmacyObj)
    }
}
