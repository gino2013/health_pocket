//
//  FaceIdSettingAlertVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/21.
//

import UIKit

protocol FaceIdSettingAlertVCDelegate: AnyObject {
    func clickSettingNowBtn()
    func clickNotSettingBtn()
}

class FaceIdSettingAlertVC: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmButton: UICustomButton!
    @IBOutlet weak var cancelButton: UICustomButton!
    
    weak var delegate: FaceIdSettingAlertVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        cancelButton.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.33) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.view.backgroundColor = .clear
    }
   
    @IBAction func confirmAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.clickSettingNowBtn()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.clickNotSettingBtn()
    }
}
