//
//  AuthPrivacyPolicyViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/12.
//

import UIKit

class AuthPrivacyPolicyViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectPrivacy: SelectPrivacy!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentInfoView: UIView!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var gIsCheckBoxEnable: Bool = false
    weak var delegate: FaceIdPrivacyPolicyVCDelegate?
    var currentFaceIdPrivacyPresentType: FaceIdPrivacyPresentType = .mainMenu
    var hospitalName: String = ""
    
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
        
        /*
         UIView.animate(withDuration: 0.33) {
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.76)
         }
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.view.backgroundColor = .clear
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = MemeberAuthViewController.instance()
        vc.currentHospital = hospitalName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AuthPrivacyPolicyViewController {
    func updateUI() {
        //topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        scrollView.delegate = self
        
        scrollView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        selectPrivacy.firstLabel.text = "我已閱畢，並同意上述聲明"
        selectPrivacy.secondLabel.isHidden = true
        selectPrivacy.secondLabelButton.isHidden = true
        selectPrivacy.delegate = self
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextButton.setTitleColor(UIColor.lightGray, for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        
        contentInfoView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        // 设置 Home Indicator 的背景颜色
        /*
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let homeIndicatorView = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            homeIndicatorView.backgroundColor = UIColor.red  // 这里设置为你想要的背景颜色
            window?.addSubview(homeIndicatorView)
        }
         */
        
        titleLabel.text = "同意使用\(hospitalName)醫療資料授權"
    }
}

extension AuthPrivacyPolicyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

extension AuthPrivacyPolicyViewController: SelectPrivacyDelegate {
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
