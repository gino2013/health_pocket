//
//  JSONEncodable.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

protocol JSONEncodable {
    func serialize() -> Data?
}
