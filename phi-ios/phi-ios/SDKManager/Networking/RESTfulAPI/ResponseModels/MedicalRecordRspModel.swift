//
//  MedicalRecordRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/14.
//

import Foundation

/*
"medicalRecordNo": "001",
"name": "李查爾",
"opdDate": "2024-03-08", // 小卡右上就診日期
"departmentName": "家醫科",
"physicianName": "王人清", // 醫事人員
"medicalType": "1", // 1-門診, 2-運動課程
"medicalTypeDesc": "門診"
"icdName": "第二型糖尿病", // 疾病分類
"prescriptionNo": "AC001",
"startDate": "2025-01-15", // 處方簽開始日期
"endDate": "2024-03-14", // 處方簽結束日期
"refillTimes": 3, // 可調劑次數
"receivedTimes": "2", // 已調劑次數
"perReceiveDays": 30, // 每次調劑量（單位都是日)
"receiveStatus": "2", // 領藥狀態: 0-已領藥、1-已預約、2-可領藥
"receiveStatusDesc": "可領藥",
"nthReceiveTime": 3, // 第幾次領藥
"tenantId": "2344266689",
"organizationName": "健康醫院" // 小卡title醫院名稱
*/

class MedicalRecordRspModel: JSONDecodable {
    var diagnosisNo: String
    var medicalRecordNo: String
    var name: String
    var opdDate: String
    var departmentName: String
    var physicianName: String
    var medicalType: String // 1-門診, 2-運動課程
    var medicalTypeDesc: String
    var icdName: String // 疾病分類
    var prescriptionNo: String
    //var startDate: String // 處方簽開始日期
    var endDate: String // 處方簽結束日期
    var refillTimes: Int // 可調劑次數
    var perReceiveDays: Int // 每次調劑量（單位都是日)
    var receiveStatus: String // 領藥狀態: 0-已領藥、1-已預約、2-可領藥
    var receiveStatusDesc: String
    var nthReceiveTime: Int // 第幾次領藥
    var receivedTimes: String // 已調劑次數
    var tenantId: String
    var hospitalName: String // 小卡title醫院名稱
    var isPrescriptionEnded: Bool
    // var expanded: Bool
    
    required init(json: JSON) {
        diagnosisNo = json["diagnosisNo"].stringValue
        medicalRecordNo = json["medicalRecordNo"].stringValue
        name = json["name"].stringValue
        opdDate = json["opdDate"].stringValue
        departmentName = json["departmentName"].stringValue
        physicianName = json["physicianName"].stringValue
        medicalType = json["medicalType"].stringValue
        medicalTypeDesc = json["medicalTypeDesc"].stringValue
        icdName = json["icdName"].stringValue
        prescriptionNo = json["prescriptionNo"].stringValue
        //startDate = json["startDate"].stringValue
        endDate = json["endDate"].stringValue
        refillTimes = json["refillTimes"].intValue
        perReceiveDays = json["perReceiveDays"].intValue
        receiveStatus = json["receiveStatus"].stringValue
        receiveStatusDesc = json["receiveStatusDesc"].stringValue
        nthReceiveTime = json["nthReceiveTime"].intValue
        receivedTimes = json["receivedTimes"].stringValue
        tenantId = json["tenantId"].stringValue
        hospitalName = json["hospitalName"].stringValue
        isPrescriptionEnded = json["isPrescriptionEnded"].boolValue
        // expanded = false
    }
}
