//
//  MedicalDeptListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/9.
//

import Foundation

class MedicalDeptListRspModel: JSONDecodable {
    var dataArray: Array<MedicalDeptRspModel>? = nil

    required init(json: JSON) {
        let dataList = json
        var medicalDeptList = [MedicalDeptRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let medicalDeptItem = MedicalDeptRspModel(json: item)
                medicalDeptList.append(medicalDeptItem)
            }
        }

        dataArray = medicalDeptList
    }
}
