//
//  ButtonCollectionViewCell.swift
//  phi-ios
//
//  Created by Kenneth on 2019/8/29.
//

import UIKit

protocol ButtonCollectionViewCellDelegate {
    func buttonTap()
}

class ButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeButton: UIButton!
    
    var delegate: ButtonCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeButton.backgroundColor = UIColor.white
        typeButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        typeButton.setTitleColor(UIColor.lightGray, for: .disabled)
        typeButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        typeButton.layer.borderWidth = 1.0
        // 设置按钮的左右边距（内边距）
        typeButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 16, bottom: 3, right: 16)
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        delegate?.buttonTap()
    }
    
    func configureCell(btnTitle: String, isSelected: Bool = false) {
        //typeButton.setTitle(btnTitle, for: .normal)
        //typeButton.isEnabled = isSelected
        
        UIView.performWithoutAnimation {
            typeButton.setTitle(btnTitle, for: .normal)
            typeButton.isEnabled = isSelected
            typeButton.layoutIfNeeded()
        }
        
        if isSelected {
            typeButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            typeButton.backgroundColor = UIColor.white
            typeButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        } else {
            typeButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1.0)!.cgColor
            typeButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            typeButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
}
