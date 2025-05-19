//
//  MedicinesRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/14.
//

import Foundation

/*
 "itemNo": "001",
 "healthInsurenceCode": "CC1234",
 "medicineCode": "AL1234",
 "medicineName": "停敏膜衣錠５毫克", // 藥名
 "medicineScientificName": "DENOSIN",
 "dosageQuantityPerTime": 1, // 用量
 "dosageUnitPerTime": "顆", // 用量單位
 "doseUseInstruction": "QD",
 "doseUseInstructionDesc": "每日三餐飯後1次", // 用法
 "doseUseTiming": "飯後",
 "doseType": "藥丸",
 "doseUseMethod": "口服",
 "dosingDays": 90,
 "totalDosageQuantity": 90,
 "totalDosageUnit": "顆",
 "remark": "",
 "atOwnExpenseMark": ""
 */

/*
 "item": "001",
 "medicineCode": "AL1234",
 "brandName": "停敏膜衣錠５毫克",
 "genericName": "DENOSIN",
 "dose": 1,
 "doseUnits": "顆",
 "usagetime": "QD",
 "usagetimeDesc": "每日一次",
 "frequencyType": "DAILY",
 "frequencyTimes": 1,
 "useTime": "OTHER",
 
 // AC("飯前"), PC("飯後"), HS("睡前"), PCHS("飯後、睡前"), ACHS("飯前、睡前"), OTHER("其他時段");
 */

class MedicinesRspModel: JSONDecodable {
    var item: String
    var healthInsurenceCode: String
    var medicineCode: String
    var brandName: String
    var genericName: String
    var dose: Int
    var doseUnits: String
    var usagetime: String
    var usagetimeDesc: String
    var frequencyType: String
    var frequencyTimes: Int
    var useTime: String
    var doseUseTiming: String
    var doseType: String
    var doseUseMethod: String
    var dosingDays: Int
    var totalDosageQuantity: Int
    var totalDosageUnit: String
    var remark: String
    var atOwnExpenseMark: String
    
    required init(json: JSON) {
        item = json["item"].stringValue
        healthInsurenceCode = json["healthInsurenceCode"].stringValue
        medicineCode = json["medicineCode"].stringValue
        brandName = json["brandName"].stringValue
        genericName = json["genericName"].stringValue
        dose = json["dose"].intValue
        doseUnits = json["doseUnits"].stringValue
        usagetime = json["usagetime"].stringValue
        usagetimeDesc = json["usagetimeDesc"].stringValue
        frequencyType = json["frequencyType"].stringValue
        frequencyTimes = json["frequencyTimes"].intValue
        useTime = json["useTime"].stringValue
        doseUseTiming = json["doseUseTiming"].stringValue
        doseType = json["doseType"].stringValue
        doseUseMethod = json["doseUseMethod"].stringValue
        dosingDays = json["dosingDays"].intValue
        totalDosageQuantity = json["totalDosageQuantity"].intValue
        totalDosageUnit = json["totalDosageUnit"].stringValue
        remark = json["remark"].stringValue
        atOwnExpenseMark = json["atOwnExpenseMark"].stringValue
    }
}
