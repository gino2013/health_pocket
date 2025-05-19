//
//  LoginInputView.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/21.
//

import UIKit

protocol LoginInputViewDelegate: AnyObject {
    func checkBoxStatus(isSelect: Bool)
    func clickForgetPwThenPushView()
}

@IBDesignable
class LoginInputView: UIView, NibOwnerLoadable {
    
    @IBInspectable var hint: String = "" {
        didSet {
            hintLabel.text = hint
        }
    }
    
    @IBInspectable var text: String = "" {
        didSet {
            textField.text = text
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var errorNote: String = "" {
        didSet {
            errorNoteLabel.text = errorNote
        }
    }
    
    @IBInspectable var isEyeHidden: Bool = true {
        didSet {
            eyeImageView.isHidden = isEyeHidden
            eyeButton.isHidden = isEyeHidden
        }
    }
    
    @IBInspectable var isRequired: Bool = true {
        didSet {
            dystLabel.isHidden = !isRequired
        }
    }
    
    @IBInspectable var isRememberMe: Bool = true {
        didSet {
            checkboxImageView.isHidden = !isRememberMe
            rememberMeLabel.isHidden = !isRememberMe
            checkBoxButton.isHidden = !isRememberMe
            forgetPwButton.isHidden = isRememberMe
        }
    }
    
    @IBInspectable var isForgetPw: Bool = true {
        didSet {
            checkboxImageView.isHidden = isForgetPw
            rememberMeLabel.isHidden = isForgetPw
            checkBoxButton.isHidden = isForgetPw
            forgetPwButton.isHidden = !isForgetPw
        }
    }
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var dystLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorNoteLabel: UILabel!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var eyeButton: UIButton!
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var forgetPwButton: UIButton!
    
    var isEyeClose: Bool = true
    var isValidatePass: Bool = false
    var isCheckBoxEnable: Bool = false {
        didSet {
            if isCheckBoxEnable {
                checkboxImageView.image = UIImage(named: "checkbox_active")
            } else {
                checkboxImageView.image = UIImage(named: "checkbox_default")
            }
        }
    }
    weak var delegate: LoginInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadNibContent()
    }
    
    func setupView() {
        hintLabel.text = hint
        dystLabel.text = "*"
        textField.text = text
        textField.placeholder = placeholder
        textField.isSecureTextEntry = false
        
        //errorNoteLabel.text = ""
        errorNoteLabel.isHidden = true
        
        baseView.layer.cornerRadius = 6
        baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
        baseView.layer.borderWidth = 1
        baseView.layer.masksToBounds = true
        
        isEyeHidden = true
    }
    
    @IBAction func clickEyeAction(_ sender: UIButton) {
        isEyeClose = !isEyeClose
        
        if isEyeClose {
            eyeImageView.image = UIImage(named: "eye_close")
            textField.isSecureTextEntry = true
            textField.resignFirstResponder()
            //textField.setNeedsDisplay()
            //textField.setNeedsLayout()
        } else {
            eyeImageView.image = UIImage(named: "eye_open")
            textField.isSecureTextEntry = false
            textField.resignFirstResponder()
            //textField.setNeedsDisplay()
            //textField.setNeedsLayout()
        }
    }
    
    @IBAction func clickCheckBoxAction(_ sender: UIButton) {
        isCheckBoxEnable = !isCheckBoxEnable
        delegate?.checkBoxStatus(isSelect: isCheckBoxEnable)
    }
    
    @IBAction func clickForgetPwAction(_ sender: UIButton) {
        delegate?.clickForgetPwThenPushView()
    }
}
