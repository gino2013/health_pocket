//
//  InsurancePrivacyPolicyVC.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/16.
//

import UIKit

class InsurancePrivacyPolicyVC: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectPrivacy: SelectPrivacy!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentInfoView: UIView!
    
    var gIsCheckBoxEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = TrialCalcViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension InsurancePrivacyPolicyVC {
    func updateUI() {
        titleLabel.text = "免責聲明與事項"
        
        scrollView.delegate = self

        //scrollView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        selectPrivacy.firstLabel.text = "我已閱畢，並同意上述聲明"
        selectPrivacy.secondLabel.isHidden = true
        selectPrivacy.secondLabelButton.isHidden = true
        selectPrivacy.delegate = self
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.setTitleColor(UIColor.lightGray, for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        
        contentInfoView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
    }
}

extension InsurancePrivacyPolicyVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension InsurancePrivacyPolicyVC: SelectPrivacyDelegate {
    func presetPrivacyPolicy(sender: UIButton) {
        // N/A
    }
    
    func checkBoxStatus(isSelect: Bool) {
        self.gIsCheckBoxEnable = isSelect
        
        nextButton.isEnabled = gIsCheckBoxEnable
        
        if gIsCheckBoxEnable {
            nextButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        } else {
            nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        }
    }
}
