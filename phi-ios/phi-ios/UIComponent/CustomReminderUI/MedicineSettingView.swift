//
//  MedicineSettingView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/8/8.
//

import UIKit

protocol MedicineSettingViewDelegate: AnyObject {
    func textFieldDidChange()
}

@IBDesignable
class MedicineSettingView: UIView, NibOwnerLoadable, UITextFieldDelegate {

    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var drugNameTextField: UITextField!
    @IBOutlet weak var drugAliasTextField: UITextField!
    @IBOutlet weak var perDoseTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    @IBOutlet weak var takingTimeTextField: UITextField!
    
    @IBInspectable var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var addviewShadow: Bool = false {
        didSet {
            addBaseViewShadow()
        }
    }
    
    @IBInspectable var drugNameText: String = "" {
        didSet {
            drugNameTextField.text = drugNameText
        }
    }
    
    @IBInspectable var drugAliasText: String = "" {
        didSet {
            drugAliasTextField.text = drugAliasText
        }
    }
    
    @IBInspectable var perDoseText: String = "" {
        didSet {
            perDoseTextField.text = perDoseText
        }
    }
    
    @IBInspectable var usageText: String = "" {
        didSet {
            usageTextField.text = usageText
        }
    }
    
    @IBInspectable var takingTimeText: String = "" {
        didSet {
            takingTimeTextField.text = takingTimeText
        }
    }
    
    weak var delegate: MedicineSettingViewDelegate?
    var currentIndex: Int = 0
    var usageTime: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadNibContent()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func addBaseViewShadow() {
        bView.layer.cornerRadius = 12
        bView.clipsToBounds = true
        bView.layer.masksToBounds = false
        bView.layer.shadowRadius = 12
        bView.layer.shadowOpacity = 0.1
        bView.layer.shadowOffset = CGSize(width: 1, height: 2)
        bView.layer.shadowColor = UIColor(hex: "#272C2E", alpha: 1.0)!.cgColor
    }
    
    func setupView() {
        titleLabel.text = titleText
        drugNameTextField.text = drugNameText
        drugAliasTextField.text = drugAliasText
        perDoseTextField.text = perDoseText
        usageTextField.text = usageText
        takingTimeTextField.text = takingTimeText
        
        drugNameTextField.borderStyle = .none
        drugAliasTextField.borderStyle = .none
        perDoseTextField.borderStyle = .none
        usageTextField.borderStyle = .none
        takingTimeTextField.borderStyle = .none
        
        // 確保 layer 沒有邊框
        drugNameTextField.layer.borderWidth = 0
        drugNameTextField.layer.borderColor = UIColor.clear.cgColor
        drugAliasTextField.layer.borderWidth = 0
        drugAliasTextField.layer.borderColor = UIColor.clear.cgColor
        perDoseTextField.layer.borderWidth = 0
        perDoseTextField.layer.borderColor = UIColor.clear.cgColor
        usageTextField.layer.borderWidth = 0
        usageTextField.layer.borderColor = UIColor.clear.cgColor
        takingTimeTextField.layer.borderWidth = 0
        takingTimeTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidChange()
    }
}
