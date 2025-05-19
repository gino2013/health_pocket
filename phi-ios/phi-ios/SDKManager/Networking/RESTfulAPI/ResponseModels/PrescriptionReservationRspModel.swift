//
//  PrescriptionReservationRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/13.
//

import Foundation

/*
 "receiveRecordId": 0
 */

class PrescriptionReservationRspModel: JSONDecodable {
    var receiveRecordId: Int
    
    required init(json: JSON) {
        receiveRecordId = json["receiveRecordId"].intValue
    }
}
