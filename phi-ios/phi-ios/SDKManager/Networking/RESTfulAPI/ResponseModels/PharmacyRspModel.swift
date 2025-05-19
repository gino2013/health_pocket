//
//  PharmacyRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/24.
//

import Foundation

class PharmacyRspModel: JSONDecodable {
    var id: String
    var code: String
    var name: String
    var address: String
    var contactPhone: String
    var businessHours: Array<String>
    var partner: Bool

    required init(json: JSON) {
        id = json["id"].stringValue
        code = json["code"].stringValue
        name = json["name"].stringValue
        address = json["address"].stringValue
        contactPhone = json["contactPhone"].stringValue
        
        var businessHoursArray = [String]()
        for (_, hourObj): (String, JSON) in json["businessHours"] {
            businessHoursArray.append(hourObj.stringValue)
        }
        businessHours = businessHoursArray
        
        partner = json["partner"].boolValue
    }
}
