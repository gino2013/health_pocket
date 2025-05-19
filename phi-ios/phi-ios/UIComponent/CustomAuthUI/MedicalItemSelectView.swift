//
//  MedicalItemSelectView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/4/16.
//

import UIKit

enum MedicalItemType: Int {
    case HomeMedicine
    case InternalMedicine
    case Gastroenterology
    case none
}

protocol MedicalItemSelectViewDelegate: AnyObject {
    func selectMedicalItem(itemType: MedicalItemType, itemIndex: Int)
    func deSelectMedicalItem(itemType: MedicalItemType, itemIndex: Int)
}

@IBDesignable
class MedicalItemSelectView: UIView, NibOwnerLoadable {

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
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var currentItemType: MedicalItemType = .none
    var isSelect: Bool = false {
        didSet {
            if isSelect {
                selectButton.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                selectButton.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    weak var delegate: MedicalItemSelectViewDelegate?
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
    
    @IBAction func clickNextAction(_ sender: UIButton) {
        isSelect = !isSelect
        
        if isSelect {
            //selectButton.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            delegate?.selectMedicalItem(itemType: currentItemType, itemIndex: currentIndex)
        } else {
            //selectButton.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            delegate?.deSelectMedicalItem(itemType: currentItemType, itemIndex: currentIndex)
        }
    }
}
