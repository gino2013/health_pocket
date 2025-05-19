//
//  TextFieldWithoutPaste.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import UIKit

class TextFieldWithoutPaste: UITextField {
    
    var backspaceCalled: (()->())?
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let action = action.description
        if action.contains("copy") || action.contains("select"){
            return true
        }
        return false
    }
    
    override func deleteBackward() {
      super.deleteBackward()
      backspaceCalled?()
    }
}

class TextFieldWithoutSelectPaste: UITextField {
    var backspaceCalled: (()->())?
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func deleteBackward() {
      super.deleteBackward()
      backspaceCalled?()
    }
}
