//
//  GenderRadioView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/18.
//

import UIKit

protocol GenderRadioViewDelegate: AnyObject {
    func selectedStatus(selectGender: Gender)
}

@IBDesignable
class GenderRadioView: UIView, NibOwnerLoadable {
    
    @IBInspectable var hint: String = "" {
        didSet {
            hintLabel.text = hint
        }
    }
    
    @IBInspectable var isRequired: Bool = true {
        didSet {
            starLabel.isHidden = !isRequired
        }
    }
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    weak var delegate: GenderRadioViewDelegate?
    var currentGender: Gender = .M
    var isSelectMale: Bool = true {
        didSet {
            if isSelectMale {
                maleButton.setImage(UIImage(named: "RadioBtnSelect"), for: .normal)
                femaleButton.setImage(UIImage(named: "RadioBtnNoSelect"), for: .normal)
            } else {
                maleButton.setImage(UIImage(named: "RadioBtnNoSelect"), for: .normal)
                femaleButton.setImage(UIImage(named: "RadioBtnSelect"), for: .normal)
            }
        }
    }
    
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
    }
    
    @IBAction func clickMaleAction(_ sender: UIButton) {
        currentGender = .M
        isSelectMale = true
        delegate?.selectedStatus(selectGender: currentGender)
    }
    
    @IBAction func clickFemaleAction(_ sender: UIButton) {
        currentGender = .F
        isSelectMale = false
        delegate?.selectedStatus(selectGender: currentGender)
    }
}
