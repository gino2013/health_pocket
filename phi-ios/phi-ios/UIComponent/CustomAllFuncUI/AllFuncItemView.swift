//
//  AllFuncItemView.swift
//  phi-ios
//
//  Created by Kenneth on 2024/4/1.
//

import UIKit

enum AllFuncItemType: Int {
    case authorizationManagement
    case loginOlaaword
    case faceIdSetting
    case schedule
    case aboutPHI
    case logout
    case none
}

protocol AllFuncItemViewDelegate: AnyObject {
    func pushToItemPage(itemType: AllFuncItemType)
}

@IBDesignable
class AllFuncItemView: UIView, NibOwnerLoadable {
    
    @IBInspectable var itemText: String = "" {
        didSet {
            itemLabel.text = itemText
        }
    }
    
    @IBInspectable var isNextBtnHidden: Bool = false {
        didSet {
            nextButton.isHidden = isNextBtnHidden
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
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentItemType: AllFuncItemType = .none
    weak var delegate: AllFuncItemViewDelegate?
    
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
        baseView.layer.cornerRadius = 12
        baseView.clipsToBounds = true
        baseView.layer.masksToBounds = false
        baseView.layer.shadowRadius = 12
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowOffset = CGSize(width: 1, height: 2)
        baseView.layer.shadowColor = UIColor(hex: "#272C2E", alpha: 1.0)!.cgColor
    }
    
    func setupView() {
        itemLabel.text = itemText
        // 給按鈕添加按下和釋放事件處理
        nextButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        nextButton.addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(buttonReleased(_:)), for: .touchUpOutside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        baseView.alpha = 0.6
    }
    
    @objc func buttonReleased(_ sender: UIButton) {
        baseView.alpha = 1.0
    }
    
    @IBAction func clickNextAction(_ sender: UIButton) {
        delegate?.pushToItemPage(itemType: currentItemType)
    }
}
