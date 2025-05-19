//
//  TakingTimeSelectView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/12.
//

import UIKit

protocol TakingTimeSelectViewDelegate: AnyObject {
    func clickDeleteBtn(itemIndex: Int)
}

@IBDesignable
class TakingTimeSelectView: UIView, NibOwnerLoadable {

    @IBInspectable var itemText: String = "" {
        didSet {
            itemLabel.text = itemText
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
    
    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    var hasDeleteBtn: Bool = false {
        didSet {
            if hasDeleteBtn {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
        }
    }
    weak var delegate: TakingTimeSelectViewDelegate?
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
    }
    
    @IBAction func clickDeleteAction(_ sender: UIButton) {
        delegate?.clickDeleteBtn(itemIndex: currentIndex)
    }
}
