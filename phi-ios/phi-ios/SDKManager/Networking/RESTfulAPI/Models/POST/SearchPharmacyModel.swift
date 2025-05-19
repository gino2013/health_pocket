//
//  SearchPharmacyModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/11.
//

import Foundation

/*
 {
   "tenantId": "cehr-04129719-buc4g",
   "medicalType": "1",
   "diagnosisNo": "1",
   "prescriptionNo": "AC001",
   "latitude": 25.04006518182344,
   "longitude": 121.56724798465274,
   "keyword": "內湖",
   "page": 0
 }
 */

struct SearchPharmacyModel {
    let tenantId: String
    let medicalType: String
    let diagnosisNo: String
    let prescriptionNo: String
    let latitude: Double
    let longitude: Double
    let keyword: String
    let page: Int
    
    func toJSON() -> JSON {
        var json = JSON()
        json["tenantId"].string = tenantId
        json["medicalType"].string = medicalType
        json["diagnosisNo"].string = diagnosisNo
        json["prescriptionNo"].string = prescriptionNo
        json["latitude"].double = latitude
        json["longitude"].double = longitude
        json["keyword"].string = keyword
        json["page"].int = page
        return json
    }
    
    init(tenantId: String, medicalType: String, diagnosisNo: String, prescriptionNo: String, latitude: Double, longitude: Double, keyword: String, page: Int) {
        self.tenantId = tenantId
        self.medicalType = medicalType
        self.diagnosisNo = diagnosisNo
        self.prescriptionNo = prescriptionNo
        self.latitude = latitude
        self.longitude = longitude
        self.keyword = keyword
        self.page = page
    }
}
