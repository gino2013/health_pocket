//
//  MedicalAuthRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/14.
//

import Foundation

/*
 "medicalAuthorizationId": 0,
 "memberId": "string",
 "tenantId": "string",
 "organizationName": "string",
 "authorizationType": "FULL",
 "departmentCodes": "string",
 "departmentNames": "string",
 "startDate": "string",
 "endDate": "string",
 "accessToken": "string",
 "createTime": "string",
 "updateTime": "string"
*/

class MedicalAuthRspModel: JSONDecodable {
    var medicalAuthorizationId: Int
    var memberId: String
    var tenantId: String
    var organizationName: String
    var authorizationType: String
    var departmentCodes: String
    var departmentNames: String
    var startDate: String
    var endDate: String
    var accessToken: String
    var createTime: String
    var updateTime: String
    
    required init(json: JSON) {
        medicalAuthorizationId = json["medicalAuthorizationId"].intValue
        memberId = json["memberId"].stringValue
        tenantId = json["tenantId"].stringValue
        organizationName = json["organizationName"].stringValue
        authorizationType = json["authorizationType"].stringValue
        departmentCodes = json["departmentCodes"].stringValue
        departmentNames = json["departmentNames"].stringValue
        startDate = json["startDate"].stringValue
        endDate = json["endDate"].stringValue
        accessToken = json["accessToken"].stringValue
        createTime = json["createTime"].stringValue
        updateTime = json["updateTime"].stringValue
    }
}
