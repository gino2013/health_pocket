//
//  PrescriptionStatusRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/20.
//

import Foundation

/*
 "hasOngoingStatusPrescription": true
 */

class PrescriptionStatusRspModel: JSONDecodable {
    var hasOngoingStatusPrescription: Bool
    
    required init(json: JSON) {
        hasOngoingStatusPrescription = json["hasOngoingStatusPrescription"].boolValue
    }
}
