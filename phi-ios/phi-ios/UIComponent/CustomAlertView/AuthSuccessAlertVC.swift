//
//  AuthSuccessAlertVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/17.
//

import UIKit

protocol AuthSuccessAlertVCDelegate: AnyObject {
    func clickContinueBtn()
    func clickMedicalHistoryBtn()
}

class AuthSuccessAlertVC: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmButton: UICustomButton!
    @IBOutlet weak var cancelButton: UICustomButton!
    
    weak var delegate: AuthSuccessAlertVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        confirmButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        */
        confirmButton.backgroundColor = UIColor.white
        confirmButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        confirmButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        confirmButton.layer.borderWidth = 1.0
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
        delegate?.clickContinueBtn()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.clickMedicalHistoryBtn()
    }
}
