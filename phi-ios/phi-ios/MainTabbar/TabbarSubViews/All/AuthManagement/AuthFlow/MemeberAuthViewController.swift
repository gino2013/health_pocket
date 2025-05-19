//
//  MemeberAuthViewController.swift
//  pho-ios
//
//  Created by Kenneth on 2024/4/12.
//

import UIKit
import KeychainSwift
import ProgressHUD

class MemeberAuthViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idrtofItView: RgterInputView!
    @IBOutlet weak var svvpimyItView: RgterInputView!
    @IBOutlet weak var notyjfsuItView: RgterInputView!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentHospital: String = ""
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "授權認證"
        replaceBackBarButtonItem()
        updateUI()
        getMemberInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateUI() {
        idrtofItView.isEditable = false
        idrtofItView.isValidatePass = true
        idrtofItView.textField.isSecureTextEntry = false
        
        svvpimyItView.isEditable = false
        svvpimyItView.isValidatePass = true
        svvpimyItView.textField.isSecureTextEntry = false
        
        notyjfsuItView.isEditable = false
        notyjfsuItView.isValidatePass = true
        notyjfsuItView.textField.isSecureTextEntry = false
        
        // Remove *
        idrtofItView.isRequired = false
        svvpimyItView.isRequired = false
        notyjfsuItView.isRequired = false

        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        saveButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func useUserInfoUpdateUI(userInfo: MemberRspModel) {
        idrtofItView.textField.text = userInfo.officialNumber
        svvpimyItView.textField.text = userInfo.memberAccount
        notyjfsuItView.textField.text = userInfo.birthDate
        titleLabel.text = "\(currentHospital)醫療資料授權"
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let vc = AuthTypeViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemeberAuthViewController {
    static func instance() -> MemeberAuthViewController {
        let viewController = MemeberAuthViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension MemeberAuthViewController {
    func getMemberInfo() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.requestFindMember() {
            (responseModel: PhiResponseModel<MemberRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let memberRspModel = responseModel.data else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.useUserInfoUpdateUI(userInfo: memberRspModel)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getMemberInfo()
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib(nibName: "VerifyResultAlertVC", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        alertViewController.alertType = .none
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
