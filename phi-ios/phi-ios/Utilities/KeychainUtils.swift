//
//  KeyChainUtils.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/6/24.
//

import Foundation
import KeychainSwift

class KeychainUtils {
    class func clearKeychain() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
}
