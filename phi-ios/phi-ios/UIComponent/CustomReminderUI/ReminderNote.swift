//
//  ReminderNote.swift
//  phi-ios
//
//  Created by Kenneth on 2024/7/15.
//

import UIKit

protocol ReminderNoteViewDelegate: AnyObject {
    func clickMoreBtn(itemIndex: Int)
}

@IBDesignable
class ReminderNote: UIView, NibOwnerLoadable {

    @IBInspectable var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
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
    
    @IBInspectable var takeTimeText: String = "" {
        didSet {
            takeTimeLabel.text = takeTimeText
        }
    }
    
    @IBInspectable var dateIntervalText: String = "" {
        didSet {
            dateIntervalLabel.text = dateIntervalText
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var addviewShadow: Bool = true {
        didSet {
            addBaseViewShadow()
        }
    }
    
    weak var delegate: ReminderNoteViewDelegate?
    var currentIndex: Int = 0
    
    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var useDaysLabel: UILabel!
    @IBOutlet weak var takeTimeLabel: UILabel!
    @IBOutlet weak var dateIntervalLabel: UILabel!
    
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
        bView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        bView.layer.borderWidth = 0.5
        //bView.layer.masksToBounds = false
        //bView.layer.shadowRadius = 12
        //bView.layer.shadowOpacity = 0.1
        //bView.layer.shadowOffset = CGSize(width: 1, height: 2)
        //bView.layer.shadowColor = UIColor(hex: "#272C2E", alpha: 1.0)!.cgColor
    }
    
    func setupView() {
        titleLabel.text = titleText
        medicineNameLabel.text = medicineNameText
        useDaysLabel.text = useDaysText
        takeTimeLabel.text = takeTimeText
        dateIntervalLabel.text = dateIntervalText
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        delegate?.clickMoreBtn(itemIndex: currentIndex)
    }
}
