//
//  MedicalPartnerRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/7.
//

import Foundation

/*
   "returnCode": "0001",
   "returnDesc": "資料格式不正確",
   "returnData": [
     {
       "id": 0,
       "tenantId": "string",
       "organizationName": "string",
       "secretCode": "string",
       "organizationHost": "string",
       "hasAuthorized": true
 
      "id": 1,
      "tenantId": "cehr-04129719-buc4g",
      "organizationCode": "",
      "organizationName": "國泰醫院",
      "organizationHost": "https://phi-gl/phi-gl",
      "hasAuthorized": true
     }
   ]
 */
class MedicalPartnerRspModel: JSONDecodable {
    var id: Int
    var tenantId: String
    var organizationName: String
    var secretCode: String
    var organizationHost: String
    var hasAuthorized: Bool

    required init(json: JSON) {
        id = json["id"].intValue
        tenantId = json["tenantId"].stringValue
        organizationName = json["organizationName"].stringValue
        secretCode = json["secretCode"].stringValue
        organizationHost = json["organizationHost"].stringValue
        hasAuthorized = json["hasAuthorized"].boolValue
    }
}
