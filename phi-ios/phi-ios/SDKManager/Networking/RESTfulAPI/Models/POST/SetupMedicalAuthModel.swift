//
//  SetupMedicalAuthModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/9.
//

import Foundation
/*
 {
 "partnerId": 1,  <- 合作夥伴，醫院ID
 "memberId": "38400000-8cf0-11bd-b23e-10b96e4ef00d",  <-會員ID
 "departmentCodes": [
 "D01", "D02", "D25"   <-勾選的醫療科別
 ],
 "departmentNames": [
 "牙科", "神經科", "一般內科"  <--這個有機會在前端組成嗎?
 ],
 "type": "FULL",    <--FULL:完全授權, RANGE:區間授權
 "startDate": null,  <--FULL時，可不傳或是null
 "endDate": null    <--FULL時，可不傳或是null
 }
 */

class SetupMedicalAuthModel {
    var partnerId: Int
    var departmentCodes: [String]
    var departmentNames: [String]
    var type: String
    var startDate: String
    var endDate: String
    
    func toJSON() -> [String: Any] {
        return [
            "partnerId": partnerId,
            "departmentCodes": departmentCodes,
            "departmentNames": departmentNames,
            "type": type,
            "startDate": startDate,
            "endDate": endDate
        ]
    }
    
    init(partnerId: Int, departmentCodes: [String], departmentNames: [String], type: String, startDate: String, endDate: String) {
        self.partnerId = partnerId
        self.departmentCodes = departmentCodes
        self.departmentNames = departmentNames
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
    }
}
