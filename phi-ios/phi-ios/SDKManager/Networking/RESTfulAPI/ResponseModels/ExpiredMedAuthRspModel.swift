//
//  ExpiredMedAuthRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/17.
//

import Foundation

/*
 {
 "medicalAuthId": 4,
 "partnerId": 1,
 "partnerOrgCode": "cehr-04129719-buc4g",
 "partnerOrgName": "國泰醫療財團法人國泰綜合醫院"
 
    "medicalAuthId": 3,
    "partnerId": 1,
    "tenantId": "cehr-04129719-buc4g",
    "partnerOrgName": "國泰醫院"
 }
 */

class ExpiredMedAuthRspModel: JSONDecodable {
    var medicalAuthId: Int
    var partnerId: Int
    var tenantId: String
    var partnerOrgName: String
    
    required init(json: JSON) {
        medicalAuthId = json["medicalAuthId"].intValue
        partnerId = json["partnerId"].intValue
        tenantId = json["tenantId"].stringValue
        partnerOrgName = json["partnerOrgName"].stringValue
    }
}
