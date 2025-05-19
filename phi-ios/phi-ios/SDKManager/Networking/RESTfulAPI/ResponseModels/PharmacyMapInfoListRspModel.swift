//
//  PharmacyMapInfoListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/11.
//

import Foundation

/*
 "returnData": {
     "pharmacys": [
       {
         "id": "string",
         "code": "string",
         "name": "string",
         "address": "string",
         "contactPhone": "string",
         "businessHours": [
           "string"
         ],
         "latitude": 0,
         "longitude": 0,
         "isPartner": true,
         "isLastReceive": true,
         "distance": 0
       }
     ],
     "hasNextPage": true
   }
 */

class PharmacyMapInfoListRspModel: JSONDecodable {
    var hasNextPage: Bool
    var dataArray: Array<PharmacyMapInfoRspModel>? = nil
    
    required init(json: JSON) {
        hasNextPage = json["hasNextPage"].boolValue
        
        let dataList = json["pharmacys"]
        var pharmacyMapInfoList = [PharmacyMapInfoRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let pharmacyMapInfoItem = PharmacyMapInfoRspModel(json: item)
                pharmacyMapInfoList.append(pharmacyMapInfoItem)
            }
        }

        dataArray = pharmacyMapInfoList
    }
}
