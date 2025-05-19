//
//  ReceiveRecordListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/24.
//

import Foundation

class ReceiveRecordListRspModel: JSONDecodable {
    var dataArray: Array<ReceiveRecordRspModel>? = nil

    required init(json: JSON) {
        let dataList = json
        var receiveRecordList = [ReceiveRecordRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let receiveRecordModelItem = ReceiveRecordRspModel(json: item)
                receiveRecordList.append(receiveRecordModelItem)
            }
        }

        dataArray = receiveRecordList
    }
}
