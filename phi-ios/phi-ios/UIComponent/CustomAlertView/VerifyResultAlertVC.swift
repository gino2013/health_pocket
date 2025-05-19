//
//  VerifyResultAlertVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/20.
//

import UIKit

enum VerifyResultAlertVC_Type: Int {
    case registerSuccess
    case registerFail
    case updateMemberKeyCodeFail
    // Medications have been imported into medication reminders
    case importedReminder
    case none
}

protocol VerifyResultAlertVCDelegate: AnyObject {
    func clickBtn(alertType: VerifyResultAlertVC_Type)
}

extension VerifyResultAlertVCDelegate {
    func clickBtn(alertType: VerifyResultAlertVC_Type) {}
}

class VerifyResultAlertVC: UIViewController {

    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertBtn: UIButton!
    
    weak var delegate: VerifyResultAlertVCDelegate?
    var alertType: VerifyResultAlertVC_Type = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func alertBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.clickBtn(alertType: alertType)
    }
}
