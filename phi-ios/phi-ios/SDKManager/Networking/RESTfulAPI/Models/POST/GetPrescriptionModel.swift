//
//  GetPrescriptionModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/14.
//

import Foundation

/*
   "tenantId": "cehr-04129719-buc4g",
   "medicalType": "1",
   "diagnosisNo": "1",
   "prescriptionNo": "AC001"
*/

struct GetPrescriptionModel {
    let tenantId: String
    let prescriptionNo: String
    let medicalType: String
    let diagnosisNo: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["tenantId"].string = tenantId
        json["medicalType"].string = medicalType
        json["diagnosisNo"].string = diagnosisNo
        json["prescriptionNo"].string = prescriptionNo
        
        return json
    }
    
    init(tenantId: String, prescriptionNo: String, medicalType: String, diagnosisNo: String) {
        self.tenantId = tenantId
        self.prescriptionNo = prescriptionNo
        self.medicalType = medicalType
        self.diagnosisNo = diagnosisNo
    }
}
