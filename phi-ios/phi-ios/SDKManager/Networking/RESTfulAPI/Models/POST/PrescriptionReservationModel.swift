//
//  PrescriptionReservationModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/13.
//

import Foundation

/*
 {
 "medicalType": "1",
 "diagnosisNo": "1",
 "prescriptionNo": "AC001",
 "tenantId": "cehr-04129719-buc4g",
 "pharmacyId": "fc8ed5427349cb1f98bf9dde45bcac8b",
 "action": "1"  /* 1:預約 2:取消預約 */
 }
 */

struct PrescriptionReservationModel {
    let tenantId: String
    let medicalType: String
    let diagnosisNo: String
    let prescriptionNo: String
    let pharmacyId: String
    let action: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["tenantId"].string = tenantId
        json["medicalType"].string = medicalType
        json["diagnosisNo"].string = diagnosisNo
        json["prescriptionNo"].string = prescriptionNo
        json["pharmacyId"].string = pharmacyId
        json["action"].string = action
        return json
    }
    
    init(tenantId: String, medicalType: String, diagnosisNo: String, prescriptionNo: String, pharmacyId: String, action: String) {
        self.tenantId = tenantId
        self.medicalType = medicalType
        self.diagnosisNo = diagnosisNo
        self.prescriptionNo = prescriptionNo
        self.pharmacyId = pharmacyId
        self.action = action
    }
}
