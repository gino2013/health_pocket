//
//  StopAuthAlertVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/19.
//

import UIKit

protocol StopAuthAlertVCDelegate: AnyObject {
    func clickConfirmBtn()
}

class StopAuthAlertVC: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmButton: UICustomButton!
    
    weak var delegate: StopAuthAlertVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
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
        delegate?.clickConfirmBtn()
    }
}
