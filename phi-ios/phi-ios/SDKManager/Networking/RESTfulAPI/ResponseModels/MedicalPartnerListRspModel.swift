//
//  MedicalPartnerListRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/7.
//

import Foundation

class MedicalPartnerListRspModel: JSONDecodable {
    /*
     "page": 1,
     "totalPages": 2,
     "data:[...]"
     */
    //var page: Int = 0
    //var totalPages: Int = 0
    var dataArray: Array<MedicalPartnerRspModel>? = nil

    required init(json: JSON) {
        //page = json["page"].intValue
        //totalPages = json["totalPages"].intValue
        
        //let dataList = json["data"]
        let dataList = json
        var medicalPartnerList = [MedicalPartnerRspModel]()

        if dataList.count > 0 {
            for (_, item): (String, JSON) in dataList {
                let medicalPartnerItem = MedicalPartnerRspModel(json: item)
                medicalPartnerList.append(medicalPartnerItem)
            }
        }

        dataArray = medicalPartnerList
    }
}
