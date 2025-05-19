//
//  SearchInputView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/6/5.
//

import UIKit

protocol SearchInputViewDelegate: AnyObject {
    func processInpurSearchText(searchStr: String)
}

@IBDesignable
class SearchInputView: UIView, NibOwnerLoadable {
    
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
    
    @IBInspectable var isShowSearchBtn: Bool = true {
        didSet {
            if isShowSearchBtn {
                searchButton.isHidden = false
            } else {
                searchButton.isHidden = true
            }
        }
    }
    
    @IBOutlet var bkView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorNoteLabel: UILabel!
    @IBOutlet weak var textFieldBaseView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    weak var delegate: SearchInputViewDelegate?
    
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
        
        errorNoteLabel.text = ""
        
        textFieldBaseView.layer.cornerRadius = 6
        textFieldBaseView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldBaseView.layer.borderWidth = 1
        textFieldBaseView.layer.masksToBounds = true
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        if let searchText = textField.text {
            delegate?.processInpurSearchText(searchStr: searchText)
        }
    }
}
