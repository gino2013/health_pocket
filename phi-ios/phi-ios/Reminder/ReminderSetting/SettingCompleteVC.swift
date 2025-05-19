//
//  SettingCompleteVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/11.
//

import UIKit

protocol SettingCompleteVCDelegate: AnyObject {
    func presentFrequencySettingView()
}

class SettingCompleteVC: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: SettingCompleteVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.126) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = .clear
    }
    
    @IBAction func settingDoneAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.presentFrequencySettingView()
        }
    }
}
