//
//  SelectPrivacy.swift
//  SDK
//
//  Created by Kenneth on 2023/10/3.
//

import UIKit

protocol SelectPrivacyDelegate: AnyObject {
    func checkBoxStatus(isSelect: Bool)
    func presetPrivacyPolicy(sender: UIButton)
}

@IBDesignable
class SelectPrivacy: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondLabelButton: UIButton!
    
    weak var delegate: SelectPrivacyDelegate?
    var isCheckBoxEnable: Bool = false
    
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
        //
    }
    
    @IBAction func clickCheckBoxAction(_ sender: UIButton) {
        isCheckBoxEnable = !isCheckBoxEnable
        
        if isCheckBoxEnable {
            checkboxImageView.image = UIImage(named: "checkbox_active_20x20")
        } else {
            checkboxImageView.image = UIImage(named: "checkbox_default_20x20")
        }
        delegate?.checkBoxStatus(isSelect: isCheckBoxEnable)
    }
    
    @IBAction func clickPrivacyAction(_ sender: UIButton) {
        // show 隱私權與個資使用政策
        delegate?.presetPrivacyPolicy(sender: sender)
    }
}
