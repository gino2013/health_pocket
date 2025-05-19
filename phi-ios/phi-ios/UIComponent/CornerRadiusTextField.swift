//
//  CornerRadiusTextField.swift
//  Startup
//
//  Created by Kenneth Wu on 2023/11/07.
//

import UIKit

enum CustomTextFieldType: Int {
    case register
    case setting
}

@IBDesignable class CornerRadiusTextField: UITextField {
    
    var customTextFieldType: CustomTextFieldType = .register {
        didSet {
            self.initializeTextField(customTextFieldType)
        }
    }
    
    @IBInspectable var rawValueOfTextFieldType: Int {
        get {
            return self.customTextFieldType.rawValue
        }
        set {
            if let type = CustomTextFieldType(rawValue: newValue) {
                self.customTextFieldType = type
                self.initializeTextField(type)
            }
        }
    }
    
    override func awakeFromNib() {
        initializeTextField(customTextFieldType)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        initializeTextField(customTextFieldType)
    }
    
    func initializeTextField(_ type: CustomTextFieldType) {
        leftViewMode = UITextField.ViewMode.always
        let screenWidth = UIScreen.main.bounds.width
        
        borderStyle = .none
        switch type {
        case .register:
            let ratio: CGFloat = 21.0 / 375.0
            let width = screenWidth * ratio
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            layer.cornerRadius = 4
            let value: CGFloat = 26 / 255
            layer.borderColor = UIColor(red: value, green: value, blue: value, alpha: 0.8).cgColor
            layer.borderWidth = 0.5
            backgroundColor = UIColor.lightGray
        case .setting:
            let ratio: CGFloat = 10.0 / 375.0
            let width = screenWidth * ratio
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            layer.cornerRadius = 2
            let value: CGFloat = 168 / 255
            layer.borderColor = UIColor(red: value, green: value, blue: value, alpha: 0.8).cgColor
            layer.borderWidth = 0.5
            backgroundColor = UIColor.white
            font = UIFont.systemFontOfSizeByScreenWidth(375, fontSize: 14)
        }
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
}
