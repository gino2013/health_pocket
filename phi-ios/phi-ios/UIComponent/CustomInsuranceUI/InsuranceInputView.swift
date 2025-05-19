//
//  InsuranceInputView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/18.
//

import UIKit

enum InsuranceInputType: Int {
    case diagnosisContent
    case insuranceVpzqsmuName
    case qpaovuName
    case insuredAmount
}

protocol InsuranceInputViewDelegate: AnyObject {
    func showDiagnosisSelectView()
    func showInsuranceVpzqsmuSelectView()
    func showQpaovuNameSelectView()
    func showInsuredAmountSelectView()
}

extension InsuranceInputViewDelegate {
    func showDiagnosisSelectView() {}
    func showInsuranceVpzqsmuSelectView() {}
    func showQpaovuNameSelectView() {}
    func showInsuredAmountSelectView() {}
}

@IBDesignable
class InsuranceInputView: UIView, NibOwnerLoadable {
    
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
            starLabel.isHidden = !isRequired
        }
    }
    
    @IBInspectable var enableSelectFunction: Bool = false {
        didSet {
            showSelectViewButton.isHidden = !enableSelectFunction
            blueFoldImageView.isHidden = !enableSelectFunction
        }
    }
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorNoteLabel: UILabel!
    @IBOutlet weak var showSelectViewButton: UIButton!
    @IBOutlet weak var blueFoldImageView: UIImageView!
    
    var isValidatePass: Bool = false
    var currentInputType: InsuranceInputType = .diagnosisContent
    weak var delegate: InsuranceInputViewDelegate?
    
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
        textField.text = text
        textField.placeholder = placeholder
        textField.isSecureTextEntry = false
        
        //errorNoteLabel.text = ""
        errorNoteLabel.isHidden = true
        
        baseView.layer.cornerRadius = 6
        baseView.layer.borderColor = UIColor.lightGray.cgColor
        baseView.layer.borderWidth = 1
        baseView.layer.masksToBounds = true
    }
    
    @IBAction func showSelectViewAction(_ sender: UIButton) {
        switch currentInputType {
        case .diagnosisContent:
            delegate?.showDiagnosisSelectView()
        case .insuranceVpzqsmuName:
            delegate?.showInsuranceVpzqsmuSelectView()
        case .qpaovuName:
            delegate?.showQpaovuNameSelectView()
        case .insuredAmount:
            delegate?.showInsuredAmountSelectView()
        }
    }
}
