//
//  SettingSwitchView.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/9.
//

import UIKit

protocol SettingSwitchViewDelegate: AnyObject {
    func notifySwitchStatus(isOn: Bool)
}

@IBDesignable
class SettingSwitchView: UIView, NibOwnerLoadable {
    
    @IBInspectable var mainText: String = "" {
        didSet {
            mainLabel.text = mainText
        }
    }
    
    @IBInspectable var noteText: String = "" {
        didSet {
            noteLabel.text = noteText
        }
    }
    
    @IBInspectable var itemText: String = "" {
        didSet {
            switchItemLabel.text = itemText
        }
    }
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var switchItemLabel: UILabel!
    @IBOutlet weak var functionSwitch: UISwitch!
    
    weak var delegate: SettingSwitchViewDelegate?
    
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
        mainLabel.isHidden = true
        
        baseView.layer.cornerRadius = 12
        baseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        // 設置開關開啟時的顏色
        functionSwitch.onTintColor = UIColor.init(hex: "#3399DB")
        
        // 設置開關的框架顏色
        functionSwitch.tintColor = UIColor.init(hex: "#C7C7C7")
        
        // 為開關添加動作
        functionSwitch.addTarget(self,
                                 action: #selector(switchChanged(_:)),
                                 for: .valueChanged)
        
    }
    
    // 當開關值發生變化時調用的函數
    @objc func switchChanged(_ sender: UISwitch) {
        updateStatusLabel()
    }
    
    // 更新標籤以顯示開關的狀態
    func updateStatusLabel() {
        delegate?.notifySwitchStatus(isOn: functionSwitch.isOn)
    }
}
