//
//  UIWindow+Utils.swift
//  SDK
//
//  Created by Kenneth on 2023/11/02.
//

import UIKit

extension UIWindow {
    public var foregroundViewController: UIViewController? {
        return rootViewController?.foregroundViewController
    }
}
