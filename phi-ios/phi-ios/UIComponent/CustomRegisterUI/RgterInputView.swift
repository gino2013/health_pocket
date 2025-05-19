//
//  RgterInputView.swift
//  SDK
//
//  Created by Kenneth on 2023/10/3.
//

import UIKit

protocol RgterInputViewDelegate: AnyObject {
    func showGenderSelectView()
}

@IBDesignable
class RgterInputView: UIView, NibOwnerLoadable {
    
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
    
    @IBInspectable var isEditable: Bool = true {
        didSet {
            if isEditable {
                baseView.backgroundColor = .white
                textField.backgroundColor = .white
                textField.textColor = UIColor(hex: "#434A4E", alpha: 1.0)
            } else {
                baseView.backgroundColor = UIColor(hex: "#F0F0F0", alpha: 1.0)
                textField.backgroundColor = UIColor(hex: "#F0F0F0", alpha: 1.0)
                textField.textColor = UIColor(hex: "#989898", alpha: 1.0)
            }
            textField.isEnabled = isEditable
        }
    }
    
    @IBInspectable var isRequired: Bool = true {
        didSet {
            dystLabel.isHidden = !isRequired
        }
    }
    
    @IBInspectable var enableGenderSelectFunction: Bool = false {
        didSet {
            genderButton.isHidden = !enableGenderSelectFunction
        }
    }
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var dystLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorNoteLabel: UILabel!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    
    var isEyeClose: Bool = true
    var isValidatePass: Bool = false
    weak var delegate: RgterInputViewDelegate?
    
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
        baseView.layer.borderColor = UIColor.lightGray.cgColor
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
    
    @IBAction func showGenderSelectAction(_ sender: UIButton) {
        delegate?.showGenderSelectView()
    }
}
