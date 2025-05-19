//
//  LogoutAlertVC.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/8/22.
//

import UIKit

protocol LogoutAlertVCDelegate: AnyObject {
    func clickThenLogout()
}

class LogoutAlertVC: UIViewController {

    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertBtn: UIButton!
    
    weak var delegate: LogoutAlertVCDelegate?
    
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
        delegate?.clickThenLogout()
    }
}
