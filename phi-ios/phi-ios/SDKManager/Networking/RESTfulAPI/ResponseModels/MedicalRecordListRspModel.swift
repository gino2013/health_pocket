//
//  MedicalRecordListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/14.
//

import Foundation

class MedicalRecordListRspModel: JSONDecodable {
    var dataArray: Array<MedicalRecordRspModel>? = nil

    required init(json: JSON) {
        let dataList = json["encountersAndPrescriptionDtos"]
        var medicalRecordList = [MedicalRecordRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let medicalRecordModelItem = MedicalRecordRspModel(json: item)
                medicalRecordList.append(medicalRecordModelItem)
            }
        }

        dataArray = medicalRecordList
    }
}
