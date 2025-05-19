//
//  CountExpiredMedicalRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/17.
//

import Foundation

class CountExpiredMedicalRspModel: JSONDecodable {
    public var countExpiredMedicalAuth: Int
    
    required init(json: JSON) {
        countExpiredMedicalAuth = json["countExpiredMedicalAuth"].intValue
    }
}
