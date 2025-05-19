//
//  GoogleMapRspModel.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/03/07.
//

import Foundation

struct GoogleMapResponse: Codable {
    let results: [MapInfoResults]
}

struct MapInfoResults: Codable {
    let name: String
    let vicinity: String
}
