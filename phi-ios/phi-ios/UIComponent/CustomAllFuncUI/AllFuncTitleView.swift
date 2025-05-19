//
//  AllFuncTitleView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/4/1.
//

import UIKit

@IBDesignable
class AllFuncTitleView: UIView, NibOwnerLoadable {
    
    @IBInspectable var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    @IBInspectable var iconImageName: String = "" {
        didSet {
            iconImageView.image = UIImage(named: iconImageName)
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
    func setupView() {
        titleLabel.text = titleText
    }
}
