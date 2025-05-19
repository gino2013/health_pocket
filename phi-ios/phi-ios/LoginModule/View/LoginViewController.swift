//
//  LoginViewController.swift
//  SDK
//
//  Created by Keneth on 2023/9/28.
//

import UIKit
import ProgressHUD
import LocalAuthentication
import KeychainSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var svvpimyItView: LoginInputView!
    @IBOutlet weak var olaaeptfItView: LoginInputView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var middleBaseView: UIView!
    
    @IBOutlet weak var faceIdImageView: UIImageView!
    @IBOutlet weak var faceIdLabel: UILabel!
    @IBOutlet weak var faceIdButton: UIButton!
    
    var viewModel: LoginViewModel?
    var activityIndicator: UIActivityIndicatorView!
    var errorCount = 0
    var gCurrentCheckBoxStatus: Bool = false
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //svvpimyItView.textField.placeholder = "kenneth@cathay.dev.com"
        //passwordHintTextField.textField.placeholder = "asdf1234"
        viewModel?.delegate = self
        updateUI()
        configTextFieldDelegate()
        
        /*
        let keychain = KeychainSwift()
        if (keychain.get("RSAKey") ?? "").isEmpty {
            getRsaPublicKey()
        }
         */
        getRsaPublicKey()
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        
        let versionLabel = UILabel()
        versionLabel.text = "Version: \(version ?? "N/A") (Build: \(build ?? "N/A"))"
        versionLabel.textColor = .black
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)
        
        // 添加约束
        NSLayoutConstraint.activate([
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            versionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        // 綁定 svvpimyItView 當編輯結束時觸發
        svvpimyItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 olaaeptfItView 當編輯結束時觸發
        olaaeptfItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    // checkmarx
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == svvpimyItView.textField {
            svvpimyItView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            svvpimyItView.baseView.layer.borderWidth = 1.0
            svvpimyItView.errorNoteLabel.isHidden = true
            svvpimyItView.isValidatePass = false
            
            // validate account
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
//#if targetEnvironment(simulator)
//                    svvpimyItView.isValidatePass = true
//#else
                    //if currentText.count != 10 {
                    if !ValidateUtils.isValidatePhoneNumber(currentText) {
                        svvpimyItView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        svvpimyItView.baseView.layer.borderWidth = 1.0
                        svvpimyItView.errorNoteLabel.isHidden = false
                        
                        loginButton.isEnabled = false
                        loginButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        svvpimyItView.isValidatePass = false
                        return
                    }
                    
                    svvpimyItView.isValidatePass = true
//#endif
                    
                }
            }
            
        } else if textField == olaaeptfItView.textField {
            olaaeptfItView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            olaaeptfItView.baseView.layer.borderWidth = 1.0
            olaaeptfItView.errorNoteLabel.isHidden = true
            olaaeptfItView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                // validate password
                if let currentText = textField.text {
                    if !ValidateUtils.validatePassword(currentText) {
                        olaaeptfItView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        olaaeptfItView.baseView.layer.borderWidth = 1.0
                        olaaeptfItView.errorNoteLabel.isHidden = false
                        
                        loginButton.isEnabled = false
                        loginButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        olaaeptfItView.isValidatePass = false
                        return
                    }
                    
                    olaaeptfItView.isValidatePass = true
                }
            }
        }
        
        if svvpimyItView.isValidatePass &&
            olaaeptfItView.isValidatePass {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        }
    }
        
    // checkmarx
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true // 防止螢幕截圖或休眠
    }
    
    // checkmarx
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func updateUI() {
        titleLabel.text = LocalizableKeys.loginViewTitle.localized
        
        svvpimyItView.isRequired = false
//#if targetEnvironment(simulator)
        // 這段程式碼只會在模擬器上執行
//        svvpimyItView.textField.keyboardType = .alphabet
//#else
        // 這段程式碼將在真機上執行
        svvpimyItView.textField.keyboardType = .numberPad
//#endif
        svvpimyItView.textField.isSecureTextEntry = false
        svvpimyItView.isRememberMe = true
        svvpimyItView.isForgetPw = false
        svvpimyItView.delegate = self
        
        olaaeptfItView.isRequired = false
        olaaeptfItView.textField.keyboardType = .alphabet
        olaaeptfItView.textField.isSecureTextEntry = true
        olaaeptfItView.textField.clearsOnBeginEditing = true
        olaaeptfItView.isEyeHidden = false
        olaaeptfItView.isRememberMe = false
        olaaeptfItView.isForgetPw = true
        olaaeptfItView.delegate = self
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        loginButton.setTitleColor(UIColor.lightGray, for: .disabled)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        
        middleBaseView.layer.cornerRadius = 12
        middleBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        if UserDefaults.standard.isEnableFaceId() {
            self.faceIdImageView.isHidden = false
            self.faceIdLabel.isHidden = false
            self.faceIdButton.isHidden = false
            
            /*
            FaceIdAuthHelper.shared.askBiometricAvailability { [weak self] (error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Status: \n" + error.localizedDescription)
                    DispatchQueue.main.async {
                        self.faceIdImageView.isHidden = true
                        self.faceIdLabel.isHidden = true
                        self.faceIdButton.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.faceIdImageView.isHidden = false
                        self.faceIdLabel.isHidden = false
                        self.faceIdButton.isHidden = false
                    }
                }
            }
            */
            
        } else {
            self.faceIdImageView.isHidden = true
            self.faceIdLabel.isHidden = true
            self.faceIdButton.isHidden = true
        }
        
        /*
         activityIndicator = UIActivityIndicatorView(style: .large)
         activityIndicator.center = view.center
         activityIndicator.hidesWhenStopped = true
         view.addSubview(activityIndicator)
         */
        
        if UserDefaults.standard.isSaveMe() {
            svvpimyItView.isCheckBoxEnable = true
            
            let keychain = KeychainSwift()
            let memberAccount: String = keychain.get("memberAccount") ?? ""
            svvpimyItView.textField.text = memberAccount
        } else {
            svvpimyItView.isCheckBoxEnable = false
        }
    }
    
    func configTextFieldDelegate() {
        svvpimyItView.textField.delegate = self
        olaaeptfItView.textField.delegate = self
    }
    
    // 隱藏鍵盤，如果點擊了文字方塊以外的區域
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.isSaveMe() {
            gCurrentCheckBoxStatus = true
            processEndEditing(svvpimyItView.textField)
        }
    }
    
    @IBAction func clickRegisterBtn(_ sender: UIButton) {
        let vc = RegisterViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        //ProgressHUD.animate("", interaction: false);
        //activityIndicator.startAnimating()
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        //ProgressHUD.animate(nil, .activityIndicator, interaction: false)

        PHISDK_AllResponseData.sharedInstance.memberAccountTmp = svvpimyItView.textField.text ?? ""
        PHISDK_AllResponseData.sharedInstance.olaawordTmp = olaaeptfItView.textField.text ?? ""
        //self.success(accessToken: "12345678", user: nil)
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        viewModel?.sendLogin(username: svvpimyItView.textField.text,
                             olaaword: olaaeptfItView.textField.text,
                             uuid: uuid)
    }
    
    @IBAction func clickFaceIdAction(_ sender: UIButton) {
        FaceIdAuthHelper.shared.authenticate { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                // keychain
                let keychain = KeychainSwift()
                let memberAccount: String = keychain.get("memberAccount") ?? ""
                PHISDK_AllResponseData.sharedInstance.memberAccountTmp = memberAccount
                let olaaword: String = keychain.get("olaaword") ?? ""
                PHISDK_AllResponseData.sharedInstance.olaawordTmp = olaaword
                
                DispatchQueue.main.async {
                    ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
                    ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
                    ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
                    //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
                    //self.success(accessToken: "12345678", user: nil)
                    let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
                    self.viewModel?.sendLogin(username: memberAccount,
                                         olaaword: olaaword,
                                         uuid: uuid)
                }
                
            case .failure(let failure):
                print("\(failure.localizedDescription)")
                self.BioErrorProcess(failure)
            }
        }
    }
    
    private func BioErrorProcess(_ error: LAError) {
        DispatchQueue.main.async {
            switch error.code {
            case .userCancel:
                break
            case .authenticationFailed:
                if self.errorCount < 2 {
                    self.errorCount += 1
                    /*
                    self.showAlert(title: "请再次进行指纹辨识".localized(args: []), message: "") { index in
                        self.callTouchId()
                    }
                     */
                    print("请再次进行指纹辨识")
                } else {
                    print("请改用一般登入方式")
                    
                    let errorMessage = "錯誤次數過多，請改用一般登入方式"
                    let alert = UIAlertController(title: "提示", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "確認", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            case .touchIDLockout:
                /*
                self.showAlert(title: "系统错误".localized(args: []), message: "您未允许此程序使用脸部/指纹辨识登入。请改用一般登入方式。".localized(args: [])) { index in
                    self.quickLoginToLogin()
                }
                 */
                print("您未允许此程序使用脸部/指纹辨识登入。请改用一般登入方式。")
                
                let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
                alertViewController.delegate = self
                alertViewController.messageLabel.text = "您的臉部辨識超過嘗試次數已被鎖定，請先將螢幕鎖定並以開機密碼解鎖後，再繼續使用"
                alertViewController.isKeyButtonLeft = true
                alertViewController.confirmButton.setTitle("確認", for: .normal)
                alertViewController.cancelButton.isHidden = true
                alertViewController.alertType = .faceid_fail_notice
                self.present(alertViewController, animated: true, completion: nil)
                
            case .touchIDNotEnrolled:
                /*
                self.showAlert(title: "温馨提醒".localized(args: []), message: "未检测到您有录入脸部/指纹辨识信息。请至系统设定修改。".localized(args: []), buttonTitles: ["取消".localized(), "立即设置".localized()]) { index in
                    if index == 0 { self.quickLoginToLogin()
                    } else if index == 1 {
                        guard let url = URL(string:"App-Prefs:root=General") else {return}
                        UIApplication.shared.open(url)
                    }
                }
                 */
                print("未检测到您有录入脸部/指纹辨识信息。请至系统设定修改。")
            default:
                /*
                self.showAlert(title: "指纹辨识失败".localized(args: []), message: "请改用一般登入方式".localized(args: [])) { index in
                    self.quickLoginToLogin()
                }
                 */
                print("请改用一般登入方式")
                
                let errorMessage = "請改用一般登入方式"
                let alert = UIAlertController(title: "提示", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "確認", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == svvpimyItView.textField {
//#if targetEnvironment(simulator)
            
//#else
            // 10位
            if let currentText = textField.text, currentText.count >= 10 {
                return false
            }
//#endif
        } else if textField == olaaeptfItView.textField {
            // 12位
            if let currentText = textField.text, currentText.count >= 12 {
                return false
            }
        }
        
        return true
    }
}

// MARK: - Show result
extension LoginViewController: LoginResultProtocol {
    func success(loginRspInfo: LoginRspModel?) {
        guard let loginRspInfo = loginRspInfo else {
            return
        }
        
        PHISDK_AllResponseData.sharedInstance.loginStatus = true
        
        let keychain = KeychainSwift()
        let oldMemberAccount: String = keychain.get("memberAccount") ?? ""
        
        if oldMemberAccount != PHISDK_AllResponseData.sharedInstance.memberAccountTmp {
            UserDefaultsUtils.clearUserDefaults()
        }
        
        keychain.set(PHISDK_AllResponseData.sharedInstance.memberAccountTmp, forKey: "memberAccount")
        keychain.set(PHISDK_AllResponseData.sharedInstance.olaawordTmp, forKey: "olaaword")
        // for send API
        keychain.set(loginRspInfo.idToken, forKey: "idToken")
       
        if UserDefaults.standard.isFirstLogin() == nil {
            UserDefaults.standard.setIsFirstLogin(value: true)
        }
        
        UserDefaults.standard.setIsSaveMe(value: self.gCurrentCheckBoxStatus)
        
        UserDefaults.standard.setDurationInSecond(value: loginRspInfo.durationInSecond)
        SharingManager.sharedInstance.refreshToken = loginRspInfo.refreshToken
        
        ProgressHUD.dismiss()
        
        if loginRspInfo.isSameUuid {
            let alertViewController = UINib.load(nibName: "ShowResultAlertVC") as! ShowResultAlertVC
            self.present(alertViewController, animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                alertViewController.dismiss(animated: true) {
                    self.viewModel?.coordinatorDelegate?.loginDidSuccess()
                }
            }
        } else {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.isKeyButtonLeft = false
            alertViewController.confirmButton.setTitle("取消", for: .normal)
            alertViewController.cancelButton.setTitle("確定", for: .normal)
            alertViewController.alertType = .updateUUID
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func error(errorCode: String, errorMessage: String) {
        PHISDK_AllResponseData.sharedInstance.loginStatus = false
        ProgressHUD.dismiss()
        
        if errorCode == "2001" {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = errorMessage
            alertViewController.isKeyButtonLeft = false
            alertViewController.confirmButton.setTitle("稍後再試", for: .normal)
            alertViewController.cancelButton.setTitle("忘記密碼", for: .normal)
            alertViewController.alertType = .loginError
            self.present(alertViewController, animated: true, completion: nil)
        } else if errorCode == "2002" {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = errorMessage
            alertViewController.isKeyButtonLeft = true
            alertViewController.confirmButton.setTitle("忘記密碼", for: .normal)
            alertViewController.cancelButton.isHidden = true
            alertViewController.alertType = .loginFiveError
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
            alertViewController.alertLabel.text = errorCodeMapping[errorCode] ?? errorMessage
            alertViewController.alertImageView.image = UIImage(named: "Error")
            self.present(alertViewController, animated: true, completion: nil)
        }
        //showPopup(isSuccess: false)
    }
    
    func showPopup(isSuccess: Bool, user: MemberRspModel? = nil) {
        let successMessage = "Congratulation! \(user?.email ?? "")."
        let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    func error(error: Error) {
        PHISDK_AllResponseData.sharedInstance.loginStatus = false
        
        ProgressHUD.dismiss()
        //self.activityIndicator.stopAnimating()
        showPopup(isSuccess: false)
    }
    */
}

extension LoginViewController: LoginInputViewDelegate {
    func clickForgetPwThenPushView() {
        let storyboard = UIStoryboard(name: "ForgetPWord", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPWordViewController") as! ForgetPWordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkBoxStatus(isSelect: Bool) {
        //print("isSelect = \(isSelect)!")
        gCurrentCheckBoxStatus = isSelect
    }
}

extension LoginViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        if alertType == .loginFiveError {
            clickForgetPwThenPushView()
        }
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .loginError {
            clickForgetPwThenPushView()
        } else if alertType == TwoButton_Type.updateUUID {
            updateMobileUUID()
        }
    }
}

extension LoginViewController {
    func getRsaPublicKey() {
        SDKManager.sdk.getRsaPublicKey() {
            (responseModel: PhiResponseModel<GetRSAKeyRspModel>) in
            
            if responseModel.success {
                guard let getRSAKeyRspInfo = responseModel.data else {
                    return
                }
                
                print("RSA Key = \(getRSAKeyRspInfo.key)!")
                
                let keychain = KeychainSwift()
                keychain.set(getRSAKeyRspInfo.key, forKey: "RSAKey")
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
        }
    }
    
    func updateMobileUUID() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
        
        SDKManager.sdk.requestUpdateMobileUUID() {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                let keychain = KeychainSwift()
                keychain.set(UIDevice.current.identifierForVendor?.uuidString ?? "", forKey: "uuid")
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "ShowResultAlertVC") as! ShowResultAlertVC
                    self.present(alertViewController, animated: false, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        alertViewController.dismiss(animated: true) {
                            self.viewModel?.coordinatorDelegate?.loginDidSuccess()
                        }
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.updateMobileUUID()
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
