//
//  NotifParameterRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/17.
//

import Foundation

/*
 "parameters": {
     "tenantId": "string",
     "medicalType": "string",
     "diagnosisNo": "string",
     "prescriptionNo": "string",
     "receiveRecordId": "1"
 },
 */

class NotifParameterRspModel: JSONDecodable {
    var tenantId: String
    var medicalType: String
    var diagnosisNo: String
    var prescriptionNo: String
    var receiveRecordId: String
    
    required init(json: JSON) {
        tenantId = json["tenantId"].stringValue
        medicalType = json["medicalType"].stringValue
        diagnosisNo = json["diagnosisNo"].stringValue
        prescriptionNo = json["prescriptionNo"].stringValue
        receiveRecordId = json["receiveRecordId"].stringValue
    }
}
