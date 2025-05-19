//
//  MedicineNote.swift
//  phi-ios
//
//  Created by Kenneth on 2024/5/16.
//

import UIKit

@IBDesignable
class MedicineNote: UIView, NibOwnerLoadable {

    @IBInspectable var medicineNameText: String = "" {
        didSet {
            medicineNameLabel.text = medicineNameText
        }
    }

    @IBInspectable var useDaysText: String = "" {
        didSet {
            useDaysLabel.text = useDaysText
        }
    }
    
    @IBInspectable var numberOfDayText: String = "" {
        didSet {
            numberOfDayLabel.text = numberOfDayText
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
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var useDaysLabel: UILabel!
    @IBOutlet weak var numberOfDayLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
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
        medicineNameLabel.text = medicineNameText
        useDaysLabel.text = useDaysText
        numberOfDayLabel.text = numberOfDayText
    }
}
