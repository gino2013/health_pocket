//
//  NewSettingStep1View.swift
//  phi-ios
//
//  Created by Kenneth on 2025/2/12.
//

import UIKit

protocol NewSettingStep1ViewDelegate: AnyObject {
    func clickDeleteBtn(itemIndex: Int)
    func showUnitSelectView(itemIndex: Int)
    func showUsageSelectView(itemIndex: Int)
    func showTakingTimeSelectView(itemIndex: Int)
    func textFieldDidChange()
}

@IBDesignable
class NewSettingStep1View: UIView, NibOwnerLoadable, UITextFieldDelegate {

    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var drugNameTextField: UITextField!
    @IBOutlet weak var drugAliasTextField: UITextField!
    @IBOutlet weak var perDoseTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    @IBOutlet weak var takingTimeTextField: UITextField!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var usageButton: UIButton!
    @IBOutlet weak var takingTimeButton: UIButton!
    
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
    
    @IBInspectable var unitText: String = "" {
        didSet {
            unitTextField.text = unitText
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
    
    weak var delegate: NewSettingStep1ViewDelegate?
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
        drugNameTextField.borderStyle = .none
        drugAliasTextField.borderStyle = .none
        perDoseTextField.borderStyle = .none
        unitTextField.borderStyle = .none
        usageTextField.borderStyle = .none
        takingTimeTextField.borderStyle = .none
        
        // 確保 layer 沒有邊框
        drugNameTextField.layer.borderWidth = 0
        drugNameTextField.layer.borderColor = UIColor.clear.cgColor
        drugAliasTextField.layer.borderWidth = 0
        drugAliasTextField.layer.borderColor = UIColor.clear.cgColor
        perDoseTextField.layer.borderWidth = 0
        perDoseTextField.layer.borderColor = UIColor.clear.cgColor
        unitTextField.layer.borderWidth = 0
        unitTextField.layer.borderColor = UIColor.clear.cgColor
        usageTextField.layer.borderWidth = 0
        usageTextField.layer.borderColor = UIColor.clear.cgColor
        takingTimeTextField.layer.borderWidth = 0
        takingTimeTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func clickDeleteAction(_ sender: UIButton) {
        delegate?.clickDeleteBtn(itemIndex: currentIndex)
    }
    
    @IBAction func clickUnitFieldAction(_ sender: UIButton) {
        delegate?.showUnitSelectView(itemIndex: currentIndex)
    }
    
    @IBAction func clickUsageFieldAction(_ sender: UIButton) {
        delegate?.showUsageSelectView(itemIndex: currentIndex)
    }
    
    @IBAction func clickTakingTimeFieldAction(_ sender: UIButton) {
        delegate?.showTakingTimeSelectView(itemIndex: currentIndex)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidChange()
    }
}
