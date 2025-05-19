//
//  NSArrayExtension.swift
//  Networking
//
//  Created by Kenneth Wu on 3/11/2016.
//  Copyright (c) 2016 X. All rights reserved.
//

import Foundation

extension NSArray: JSONEncodable {
    func serialize() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
