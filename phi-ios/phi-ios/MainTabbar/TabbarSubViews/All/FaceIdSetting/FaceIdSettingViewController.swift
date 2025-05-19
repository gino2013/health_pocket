//
//  FaceIdSettingViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/9.
//

import UIKit

class FaceIdSettingViewController: BaseViewController {
     
    @IBOutlet weak var faceIdSettingView: SettingSwitchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension FaceIdSettingViewController {
    func updateUI() {
        faceIdSettingView.functionSwitch.isOn = UserDefaults.standard.isEnableFaceId()
        faceIdSettingView.delegate = self
    }
}

extension FaceIdSettingViewController: SettingSwitchViewDelegate {
    func notifySwitchStatus(isOn: Bool) {
        UserDefaults.standard.setEnableFaceId(value: isOn)
        
        if isOn {
            let storyboard = UIStoryboard(name: "FaceIdPrivacyPolicy", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FaceIdPrivacyPolicyViewController") as! FaceIdPrivacyPolicyViewController
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension FaceIdSettingViewController: FaceIdSettingAlertVCDelegate, FaceIdPrivacyPolicyVCDelegate {
    func showSettingFaceIdAlert() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "您的裝置尚未設定Face ID，請先進行設定裝置開啟授權"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("下次再說", for: .normal)
        alertViewController.cancelButton.setTitle("前往設定", for: .normal)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showSettingSuccessAlert() {
        UserDefaults.standard.setEnableFaceId(value: true)
        
        let alertViewController = UINib.load(nibName: "ModifyResultAlertVC") as! ModifyResultAlertVC
        alertViewController.alertLabel.text = "設定成功"
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func clickSettingNowBtn() {
        let storyboard = UIStoryboard(name: "FaceIdPrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FaceIdPrivacyPolicyViewController") as! FaceIdPrivacyPolicyViewController
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func clickNotSettingBtn() {
        // N/A
    }
}

extension FaceIdSettingViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        // N/A
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        openBiometricSettings()
    }
    
    private func openBiometricSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
