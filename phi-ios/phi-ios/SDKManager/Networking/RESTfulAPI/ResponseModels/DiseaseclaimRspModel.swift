//
//  DiseaseclaimRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/19.
//

import Foundation

class DiseaseclaimRspModel: JSONDecodable {
    var diseaseName: String
    var remark: String
    
    required init(json: JSON) {
        diseaseName = json["diseaseName"].stringValue
        remark = json["remark"].stringValue
    }
}
