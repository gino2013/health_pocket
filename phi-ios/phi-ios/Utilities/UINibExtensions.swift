//
//  UINibExtension.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/20.
//

import UIKit

public extension UINib {
    class func load(nibName name: String, bundle: Bundle? = nil) -> Any? {
        return UINib(nibName: name, bundle: bundle)
            .instantiate(withOwner: nil, options: nil)
            .first
    }
}
