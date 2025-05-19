//
//  PrescriptionQRCodeRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/11.
//

import Foundation

/*
 "accessToken": "lmj_glv0WBsTpiGxcuiKFMQ5FIoiK1c9",
 "isPrescriptionEnded": false
 */

class PrescriptionQRCodeRspModel: JSONDecodable {
    var accessToken: String
    var isPrescriptionEnded: Bool
    
    required init(json: JSON) {
        accessToken = json["accessToken"].stringValue
        isPrescriptionEnded = json["isPrescriptionEnded"].boolValue
    }
}
