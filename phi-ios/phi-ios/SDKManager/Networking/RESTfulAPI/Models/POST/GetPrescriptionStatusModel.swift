//
//  GetPrescriptionStatusModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/20.
//

import Foundation

/*
 {
   "medicalType": "1", //目前固定帶1
   "tenantIds": [
     "cehr-04129719-buc4g",
     "cehr-04129719-buc4h"
   ]
 }
*/

struct GetPrescriptionStatusModel {
    let medicalType: String
    var tenantIds: [String]
    
    func toJSON() -> [String: Any] {
        return [
            "medicalType": medicalType,
            "tenantIds": tenantIds
        ]
    }
    
    init(medicalType: String, tenantIds: [String]) {
        self.medicalType = medicalType
        self.tenantIds = tenantIds
    }
}
