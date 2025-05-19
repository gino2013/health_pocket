//
//  UIFont+Utils.swift
//  SDK
//
//  Created by Kenneth on 2023/11/03.
//

import UIKit

public extension UIFont {
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
}
