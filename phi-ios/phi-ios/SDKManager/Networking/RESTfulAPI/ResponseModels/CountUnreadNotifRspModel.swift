//
//  CountUnreadNotifRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/17.
//

import Foundation

class CountUnreadNotifRspModel: JSONDecodable {
    public var count: Int
    
    required init(json: JSON) {
        count = json["count"].intValue
    }
}
