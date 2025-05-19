//
//  InsuranceProductRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/19.
//

import Foundation

class InsuranceProductRspModel: JSONDecodable {
    var productCode: String
    var productName: String
    var simpleCode: String
    var units: String
    
    required init(json: JSON) {
        productCode = json["productCode"].stringValue
        productName = json["productName"].stringValue
        simpleCode = json["simpleCode"].stringValue
        units = json["units"].stringValue
    }
}
