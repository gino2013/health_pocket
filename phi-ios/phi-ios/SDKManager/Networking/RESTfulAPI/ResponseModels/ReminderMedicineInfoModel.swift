//
//  ReminderMedicineInfoModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/29.
//

import Foundation

/*
 "reminderSettingMedicineInfo": {
     "medicineName": "降血壓藥",
     "medicineNameAlias": "降血壓",
     "dose": 1.0,
     "doseUnits": "顆",
     "useTime": "PC"
 }
 */

class ReminderMedicineInfoModel: JSONDecodable {
    var medicineName: String
    var medicineNameAlias: String
    var dose: Double
    var doseUnits: String
    var useTime: String
    
    required init(json: JSON) {
        medicineName = json["medicineName"].stringValue
        medicineNameAlias = json["medicineNameAlias"].stringValue
        dose = json["dose"].doubleValue
        doseUnits = json["doseUnits"].stringValue
        useTime = json["useTime"].stringValue
    }
}
