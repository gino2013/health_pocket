//
//  PrescriptionDetailRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/7.
//

import Foundation

/*
     "tenantId": "cehr-04129719-buc4g",
     "prescriptionNo": "AC001",
     "typeofPrescription": "連續處方箋",
     "opdDate": "2024/04/14",
     "endDate": "2024/07/14",
     "refillTimes": 3,
     "receivedTimes": 1,  已領幾次
     "totalMedicationsDays": 90,
     "perReceiveDays": 30,
     "receiveStatus": "2", // 0-已領藥(顯示空白qrcode), 2-可領藥(顯示qrcode), 1-預約中
     "receiveStatusDesc": "可領藥",
     "nthReceiveTime": 2, 第幾次可領藥
     "isPrescriptionEnded": false,
 
     "isReceiving": false, // 領藥中
     "recevingStepInfo": {
       "recevingStep": "1"
     },
     // "recevingStep": null // 1-調劑中, 2-領藥完成
 
     "isReserving": false, // 預約中
     "reservingStepInfo": {
       "reservingStep": "3",
       "reservationPharmacyName": "明湖藥局",
       "reservationEstimatePreparedDate": "2024/06/14"
     }
     // "reservingStep": null, // 1-送出預約, 2-預約已接受, 3-待領藥, 4-領藥完成
 */

class RecevingStepInfo: JSONDecodable {
    var recevingStep: String
    
    required init(json: JSON) {
        recevingStep = json["recevingStep"].stringValue
    }
}

class ReservingStepInfo: JSONDecodable {
    var reservingStep: String
    var reservationPharmacyName: String
    var reservationEstimatePreparedDate: String
    
    required init(json: JSON) {
        reservingStep = json["reservingStep"].stringValue
        reservationPharmacyName = json["reservationPharmacyName"].stringValue
        reservationEstimatePreparedDate = json["reservationEstimatePreparedDate"].stringValue
    }
    
}

class PrescriptionDetailRspModel: JSONDecodable {
    var tenantId: String
    var prescriptionNo: String
    var typeofPrescription: String
    var opdDate: String
    var endDate: String
    var refillTimes: Int
    var receivedTimes: Int
    var totalMedicationsDays: Int
    var perReceiveDays: Int
    var receiveStatus: String
    var receiveStatusDesc: String
    var nthReceiveTime: Int
    var isPrescriptionEnded: Bool
    var isReceiving: Bool
    var recevingStepInfo: RecevingStepInfo
    var isReserving: Bool
    var reservingStepInfo: ReservingStepInfo
    
    required init(json: JSON) {
        tenantId = json["tenantId"].stringValue
        prescriptionNo = json["prescriptionNo"].stringValue
        typeofPrescription = json["typeofPrescription"].stringValue
        opdDate = json["opdDate"].stringValue
        endDate = json["endDate"].stringValue
        refillTimes = json["refillTimes"].intValue
        receivedTimes = json["receivedTimes"].intValue
        totalMedicationsDays = json["totalMedicationsDays"].intValue
        perReceiveDays = json["perReceiveDays"].intValue
        receiveStatus = json["receiveStatus"].stringValue
        receiveStatusDesc = json["receiveStatusDesc"].stringValue
        nthReceiveTime = json["nthReceiveTime"].intValue
        isPrescriptionEnded = json["isPrescriptionEnded"].boolValue
        isReceiving = json["isReceiving"].boolValue
        
        let recevingStepInfoObj = json["recevingStepInfo"]
        recevingStepInfo = RecevingStepInfo(json: recevingStepInfoObj)
        
        isReserving = json["isReserving"].boolValue
        
        let reservingStepInfoObj = json["reservingStepInfo"]
        reservingStepInfo = ReservingStepInfo(json: reservingStepInfoObj)
    }
}
