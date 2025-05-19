//
//  ExpiredMedAuthListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/17.
//

import Foundation

class ExpiredMedAuthListRspModel: JSONDecodable {
    var dataArray: Array<ExpiredMedAuthRspModel>? = nil

    required init(json: JSON) {
        let dataList = json
        var expiredMedAuthList = [ExpiredMedAuthRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let expiredMedAuthItem = ExpiredMedAuthRspModel(json: item)
                expiredMedAuthList.append(expiredMedAuthItem)
            }
        }

        dataArray = expiredMedAuthList
    }
}
