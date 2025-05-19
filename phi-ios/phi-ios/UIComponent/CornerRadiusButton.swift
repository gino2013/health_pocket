//
//  CornerRadiusButton
//  Startup
//
//  Created by Kenneth Wu on 2023/11/07.
//

import UIKit

enum CustomButtonType: Int {
    case StartupBtn1 = 1 // R4, Blue
    case StartupBtn2 = 2 // R4, Blue
    case StartupBtn3 = 3 // R4, Blue
    case promoWebConfirm = 4 // R4, Green
    case promoTutorialBtn = 5 // R4, Clear
    case myPromoClaimBonusBtn = 7
    case myPromoViewDataBtn = 8
    case disableBtn = 9
    case cOTPVerifyBtn = 10 // R4, Green
    
    // Others
    case ok // R2, Green
    case cancel // R2, White
}

@IBDesignable class CornerRadiusButton: UIButton {
    var customButtonType: CustomButtonType = .ok {
        didSet {
            self.initializeButton(customButtonType)
            self.styleSelectedStatus(false)
        }
    }

    @IBInspectable var rawValueOfCustomButtonType: Int {
        get {
            return self.customButtonType.rawValue
        }

        set {
            if let type = CustomButtonType(rawValue: newValue) {
                self.customButtonType = type
                self.initializeButton(type)
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.styleEnableStatus(true)
            } else {
                self.styleEnableStatus(false)
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.styleSelectedStatus(true)
            } else {
                self.styleSelectedStatus(false)
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.isHighlighted {
                    self.styleSelectedStatus(true)
                } else {
                    if self.isSelected {
                        self.styleSelectedStatus(true)
                    } else {
                        self.styleSelectedStatus(false)
                    }
                }
            })
        }
    }

    private let ratio = UIScreen.aspectRatioOfWidthBy4_7()

    override func awakeFromNib() {
        initializeButton(customButtonType)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        initializeButton(customButtonType)
    }

    func initializeButton(_ type: CustomButtonType) {
        let _ = UIScreen.aspectRatioOfWidthBy4_7()
        
        switch type {
        case .StartupBtn1:
            setTitle("Show PHISDK notice", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
        case .StartupBtn2:
            setTitle("show PHISDK indicator", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
        case .StartupBtn3:
            setTitle("call PHISDK API", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
        case .promoWebConfirm:
            setTitle("立即申请", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
            
        case .promoTutorialBtn:
            setTitle("知道了", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
            layer.borderWidth = 1
            layer.borderColor = UIColor.white.cgColor
            
        case .myPromoClaimBonusBtn:
            setTitle("领取红利", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
            
        case .myPromoViewDataBtn:
            setTitle("查看已提交资料", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
            
        case .disableBtn:
            self.isEnabled = false
            
        case .cOTPVerifyBtn:
            setTitle("立即验证", for: .normal)
            setTitleColor(UIColor.white, for: .normal)
            setTitleColor(UIColor(hex: "0x000000", alpha: 0.1), for: .highlighted)
            layer.cornerRadius = 4
            
        case .ok:
            setTitle("confirm", for: .normal)
            layer.cornerRadius = 2
            
        case .cancel:
            setTitle("cancel", for: .normal)
            setTitleColor(UIColor(red: 88 / 255, green: 88 / 255, blue: 88 / 255, alpha: 1), for: .normal)
            layer.cornerRadius = 2
        }
    }

    func styleSelectedStatus(_ selected: Bool) {
        if selected {
            switch customButtonType {
            case .StartupBtn1, .StartupBtn2, .StartupBtn3:
                backgroundColor = UIColor(hex: "0x00AEEF", alpha: 1)
                layer.borderColor = UIColor(red: 175 / 255, green: 48 / 255, blue: 37 / 255, alpha: 1).cgColor
                layer.borderWidth = 0.5
            case .promoWebConfirm, .myPromoViewDataBtn:
                backgroundColor = UIColor(hex: "0x33C85D", alpha: 1)
                layer.borderColor = UIColor(red: 175 / 255, green: 48 / 255, blue: 37 / 255, alpha: 1).cgColor
                layer.borderWidth = 0.5
            case .cOTPVerifyBtn:
                backgroundColor = UIColor(hex: "0x33C85D", alpha: 1)
                layer.borderColor = UIColor(red: 175 / 255, green: 48 / 255, blue: 37 / 255, alpha: 1).cgColor
                layer.borderWidth = 0.5
            case .myPromoClaimBonusBtn:
                backgroundColor = UIColor(hex: "0x33C85D", alpha: 1)
                layer.borderColor = UIColor(red: 175 / 255, green: 48 / 255, blue: 37 / 255, alpha: 1).cgColor
                layer.borderWidth = 0.5
            case .promoTutorialBtn:
                backgroundColor = UIColor.clear
            case .ok:
                backgroundColor = UIColor(hex: "0x44A939", alpha: 1)
                layer.borderColor = UIColor(red: 62 / 255, green: 154 / 255, blue: 52 / 255, alpha: 1).cgColor
                layer.borderWidth = 0.5
            case .cancel:
                backgroundColor = UIColor(red: 222 / 255, green: 222 / 255, blue: 222 / 255, alpha: 1)
            case .disableBtn:
                backgroundColor = UIColor.gray
            }
        } else {
            switch customButtonType {
            case .StartupBtn1, .StartupBtn2, .StartupBtn3:
                backgroundColor = UIColor(hex: "0x00AEEF", alpha: 1)
                layer.borderWidth = 0
            case .promoWebConfirm, .myPromoViewDataBtn:
                backgroundColor = UIColor(hex: "0x33C85D", alpha: 1)
                layer.borderWidth = 0
            case .cOTPVerifyBtn:
                backgroundColor = UIColor(hex: "0x33C85D", alpha: 1)
                layer.borderWidth = 0
            case .myPromoClaimBonusBtn:
                backgroundColor = UIColor(hex: "0x33C85D", alpha: 1)
                layer.borderWidth = 0
            case .promoTutorialBtn:
                backgroundColor = UIColor.clear
            case .ok:
                backgroundColor = UIColor(hex: "0x52D344", alpha: 1)
                layer.borderWidth = 0
            case .cancel:
                backgroundColor = UIColor.white
            case .disableBtn:
                backgroundColor = UIColor.lightGray
            }
        }
    }

    func styleEnableStatus(_: Bool) {
        if isEnabled {
            switch customButtonType {
            case .ok:
                backgroundColor = UIColor(red: 82 / 255, green: 211 / 255, blue: 68 / 255, alpha: 1)
            default:
                break
            }
        } else {
            switch customButtonType {
            case .ok:
                backgroundColor = UIColor(red: 200 / 255, green: 199 / 255, blue: 204 / 255, alpha: 1)
            default:
                break
            }
        }
    }
}
