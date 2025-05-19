//
//  MedicinesListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/14.
//

import Foundation

class MedicinesListRspModel: JSONDecodable {
    var dataArray: Array<MedicinesRspModel>? = nil

    required init(json: JSON) {
        let dataList = json["medicines"]
        var medicalDeptList = [MedicinesRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let medicinesModelItem = MedicinesRspModel(json: item)
                medicalDeptList.append(medicinesModelItem)
            }
        }

        dataArray = medicalDeptList
    }
}
