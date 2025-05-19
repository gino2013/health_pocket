//
//  SetupExpiredMedicalAuthModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/17.
//

import Foundation
/*
 {
   "medicalAuthIds": [
     4,
     5
   ]
 }
 */

class SetupExpiredMedicalAuthModel {
    var medicalAuthIds: [Int]
    
    func toJSON() -> [String: Any] {
        return [
            "medicalAuthIds": medicalAuthIds
        ]
    }
    
    init(medicalAuthIds: [Int]) {
        self.medicalAuthIds = medicalAuthIds
    }
}
