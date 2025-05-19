//
//  TwoButtonAlertVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/21.
//

import UIKit

enum TwoButton_Type: Int {
    case loginError
    case loginFiveError
    case updateUUID
    case faceId
    case firstAuthorization
    case cancelEditProfile
    case confirmEditProfile
    case postponeAuthorization
    case postpone_cancelAuthorization_1
    case postpone_cancelAuthorization_2
    case postpone_confirmAuthorization_1
    case postpone_confirmAuthorization_2
    case receivingMedicine_completed
    case faceid_fail_notice
    case cancel_appointment
    case delete_single_reminder
    case none
}

protocol TwoButtonAlertVCDelegate: AnyObject {
    func clickLeftBtn(alertType: TwoButton_Type)
    func clickRightBtn(alertType: TwoButton_Type)
}

class TwoButtonAlertVC: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmButton: UICustomButton!
    @IBOutlet weak var cancelButton: UICustomButton!
    
    weak var delegate: TwoButtonAlertVCDelegate?
    // left button is blue
    var isKeyButtonLeft: Bool = true
    var alertType: TwoButton_Type = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isKeyButtonLeft {
            confirmButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
            confirmButton.setTitleColor(UIColor.white, for: .normal)
            //confirmButton.setTitleColor(UIColor.white, for: .highlighted)
            //confirmButton.setTitleColor(UIColor.white, for: .selected)
            //confirmButton.layer.borderColor = UIColor.systemBlue.cgColor
            //confirmButton.layer.borderWidth = 1.0
            
            cancelButton.backgroundColor = UIColor.white
            cancelButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
            //cancelButton.setTitleColor(UIColor.systemBlue, for: .highlighted)
            //cancelButton.setTitleColor(UIColor.white, for: .selected)
            cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            cancelButton.layer.borderWidth = 1.0
        } else {
            cancelButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
            cancelButton.setTitleColor(UIColor.white, for: .normal)
            
            confirmButton.backgroundColor = UIColor.white
            confirmButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
            confirmButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            confirmButton.layer.borderWidth = 1.0
        }
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
        delegate?.clickLeftBtn(alertType: self.alertType)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.clickRightBtn(alertType: self.alertType)
    }
}
