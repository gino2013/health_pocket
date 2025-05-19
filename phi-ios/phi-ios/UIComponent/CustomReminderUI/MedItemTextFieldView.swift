//
//  MedItemTextFieldView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/9.
//

import UIKit

@IBDesignable
class MedItemTextFieldView: UIView, NibOwnerLoadable {

    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var medInfoTextField: UITextField!
    @IBOutlet weak var lineView: UIView!
    
    @IBInspectable var itemText: String = "" {
        didSet {
            itemLabel.text = itemText
        }
    }
    
    @IBInspectable var infoText: String = "" {
        didSet {
            medInfoTextField.text = infoText
        }
    }

    @IBInspectable var placeholder: String = "" {
        didSet {
            medInfoTextField.placeholder = placeholder
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
    
    @IBInspectable var addBottomLine: Bool = false {
        didSet {
            lineView.isHidden = !addBottomLine
        }
    }
    
    var currentIndex: Int = 0
    
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
        itemLabel.text = itemText
        medInfoTextField.text = infoText
    }
}
