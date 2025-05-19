//
//  PrescriptionReceiveRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/12.
//

import Foundation

/*
 "receiveRecordId": 0
 */

class PrescriptionReceiveRspModel: JSONDecodable {
    var receiveRecordId: Int
    
    required init(json: JSON) {
        receiveRecordId = json["receiveRecordId"].intValue
    }
}
