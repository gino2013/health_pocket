//
//  StringModel.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

class StringModel: JSONDecodable {

    var string: String

    init(string: String) {
        self.string = string
    }

    required init(json: JSON) {
        string = json.stringValue
    }
}
