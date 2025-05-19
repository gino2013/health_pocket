//
//  UIButtonExt.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/29.
//

import UIKit

extension UIButton {
    func makeTransparent(borderWidth: CGFloat = 1.0) {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.backgroundColor = .clear
        self.setTitleColor(.clear, for: .normal)
    }
}
