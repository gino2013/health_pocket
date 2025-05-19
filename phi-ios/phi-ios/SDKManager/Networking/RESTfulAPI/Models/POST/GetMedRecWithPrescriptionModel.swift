//
//  GetMedRecWithPrescriptionModel.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/14.
//

import Foundation

struct GetMedRecWithPrescriptionModel {
    let medicalType: String
    let ongoingPrescription: Bool
    
    func toJSON() -> JSON {
        var json = JSON()
        json["medicalType"].string = medicalType
        json["ongoingPrescription"].bool = ongoingPrescription
        
        return json
    }
    
    init(medicalType: String, ongoingPrescription: Bool) {
        self.medicalType = medicalType
        self.ongoingPrescription = ongoingPrescription
    }
}
