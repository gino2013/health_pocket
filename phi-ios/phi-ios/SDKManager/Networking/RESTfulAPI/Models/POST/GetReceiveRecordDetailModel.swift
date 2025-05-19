//
//  GetReceiveRecordDetailModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/24.
//

import Foundation

/*
  "tenantId": "cehr-04129719-buc4g",
  "medicalType": "1",
  "diagnosisNo": "1",
  "prescriptionNo": "AC001",
  "receiveRecordId": "1"
 */

struct GetReceiveRecordDetailModel {
    let tenantId: String
    let prescriptionNo: String
    let medicalType: String
    let diagnosisNo: String
    let receiveRecordId: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["tenantId"].string = tenantId
        json["prescriptionNo"].string = prescriptionNo
        json["medicalType"].string = medicalType
        json["diagnosisNo"].string = diagnosisNo
        json["receiveRecordId"].string = receiveRecordId
        
        return json
    }
    
    init(tenantId: String, prescriptionNo: String, medicalType: String, diagnosisNo: String, receiveRecordId: String) {
        self.tenantId = tenantId
        self.prescriptionNo = prescriptionNo
        self.medicalType = medicalType
        self.diagnosisNo = diagnosisNo
        self.receiveRecordId = receiveRecordId
    }
}
