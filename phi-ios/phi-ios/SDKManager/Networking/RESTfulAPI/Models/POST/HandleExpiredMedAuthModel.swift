//
//  HandleExpiredMedAuthModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/19.
//

import Foundation
/*
 Request body：
 {
   "extendMedicalAuthIds": [
     1,2,3
   ],
   "terminateMedicalAuthIds": [
    4
   ]
 }
 */

class HandleExpiredMedAuthModel {
    var extendMedicalAuthIds: [Int]
    var terminateMedicalAuthIds: [Int]
    
    func toJSON() -> [String: Any] {
        return [
            "extendMedicalAuthIds": extendMedicalAuthIds,
            "terminateMedicalAuthIds": terminateMedicalAuthIds
        ]
    }
    
    init(extendMedicalAuthIds: [Int], terminateMedicalAuthIds: [Int]) {
        self.extendMedicalAuthIds = extendMedicalAuthIds
        self.terminateMedicalAuthIds = terminateMedicalAuthIds
    }
}
