//
//  MedicalFinancialVController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/1/30.
//

import UIKit

class MedicalFinancialVController: BaseViewController {
    
    @IBOutlet weak var fiFunctionAView: UIView!
    @IBOutlet weak var funcAImageView: UIImageView!
    @IBOutlet weak var funcATitleLabel: UILabel!
    @IBOutlet weak var funcASubTitleLabel: UILabel!
    @IBOutlet weak var fiFunctionBView: UIView!
    @IBOutlet weak var funcBImageView: UIImageView!
    @IBOutlet weak var funcBTitleLabel: UILabel!
    @IBOutlet weak var funcBSubTitleLabel: UILabel!
    
    @IBOutlet weak var insureButton: UIButton!
    
    var isFuncAEnable: Bool = true {
        didSet {
            if isFuncAEnable {
                funcAImageView.image = UIImage(named: "Insurance_1")
                funcATitleLabel.textColor = UIColor(hex: "#2E8BC7", alpha: 1.0)
                funcASubTitleLabel.textColor = UIColor(hex: "#434A4E", alpha: 1.0)
                insureButton.isEnabled = true
            } else {
                funcAImageView.image = UIImage(named: "Insurance_2")
                funcATitleLabel.textColor = UIColor(hex: "#C7C7C7", alpha: 1.0)
                funcASubTitleLabel.textColor = UIColor(hex: "#C7C7C7", alpha: 1.0)
                insureButton.isEnabled = false
            }
        }
    }
    var isFuncBEnable: Bool = false {
        didSet {
            if isFuncBEnable {
                funcBImageView.image = UIImage(named: "Dg_2")
                funcBTitleLabel.textColor = UIColor(hex: "#2E8BC7", alpha: 1.0)
                funcBSubTitleLabel.textColor = UIColor(hex: "#434A4E", alpha: 1.0)
            } else {
                funcBImageView.image = UIImage(named: "Dg_1")
                funcBTitleLabel.textColor = UIColor(hex: "#C7C7C7", alpha: 1.0)
                funcBSubTitleLabel.textColor = UIColor(hex: "#C7C7C7", alpha: 1.0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        fiFunctionAView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        fiFunctionBView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        isFuncAEnable = true
        isFuncBEnable = false
    }
    
    @IBAction func InsuranceCalcAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "InsurancePrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InsurancePrivacyPolicyVC") as! InsurancePrivacyPolicyVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
