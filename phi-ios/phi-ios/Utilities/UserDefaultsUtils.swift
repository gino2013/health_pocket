//
//  UserDefaultsUtils.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/24.
//

import Foundation

class UserDefaultsUtils {
    class func clearUserDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        for key in dictionary.keys {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
}
