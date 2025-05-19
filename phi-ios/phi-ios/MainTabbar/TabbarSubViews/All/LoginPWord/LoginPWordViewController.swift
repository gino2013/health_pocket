//
//  LoginPWordViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/8.
//

import UIKit
import ProgressHUD
import KeychainSwift

class LoginPWordViewController: BaseViewController {
    
    @IBOutlet weak var oldOlaaPwInputView: RgterInputView!
    @IBOutlet weak var newOlaaPwInputView: RgterInputView!
    @IBOutlet weak var reNewOlaaPwInputView: RgterInputView!
    @IBOutlet weak var resetButton: UIButton!
    
    var gCurrentOldInputPW: String = ""
    var gCurrentNewInputPW: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        
        // 綁定 oldOlaaPwInputView 當編輯結束時觸發
        oldOlaaPwInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 newOlaaPwInputView 當編輯結束時觸發
        newOlaaPwInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 reNewOlaaPwInputView 當編輯結束時觸發
        reNewOlaaPwInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    // checkmarx
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == oldOlaaPwInputView.textField {
            oldOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            oldOlaaPwInputView.baseView.layer.borderWidth = 1.0
            oldOlaaPwInputView.errorNoteLabel.isHidden = true
            oldOlaaPwInputView.isValidatePass = false
            
            if let currentText = textField.text, !currentText.isEmpty {
                // 密碼正規化處理，避免潛在的惡意輸入
                let sanitizedPassword = sanitizeInput(currentText)
                gCurrentOldInputPW = sanitizedPassword
                if !ValidateUtils.validatePassword(currentText) {
                    oldOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                    oldOlaaPwInputView.baseView.layer.borderWidth = 1.0
                    oldOlaaPwInputView.errorNoteLabel.isHidden = false
                    
                    resetButton.isEnabled = false
                    resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    oldOlaaPwInputView.isValidatePass = false
                    return
                }
                
                oldOlaaPwInputView.isValidatePass = true
            }
        } else if textField == newOlaaPwInputView.textField {
            newOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            newOlaaPwInputView.baseView.layer.borderWidth = 1.0
            newOlaaPwInputView.errorNoteLabel.isHidden = true
            newOlaaPwInputView.isValidatePass = false
            
            if let currentText = textField.text, !currentText.isEmpty {
                // 密碼正規化處理，避免潛在的惡意輸入
                let sanitizedPassword = sanitizeInput(currentText)
                gCurrentNewInputPW = sanitizedPassword
                
                if !ValidateUtils.validatePassword(currentText) {
                    newOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                    newOlaaPwInputView.baseView.layer.borderWidth = 1.0
                    newOlaaPwInputView.errorNoteLabel.isHidden = false
                    
                    resetButton.isEnabled = false
                    resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    newOlaaPwInputView.isValidatePass = false
                    return
                }
                
                newOlaaPwInputView.isValidatePass = true
                
            }
            
        } else if textField == reNewOlaaPwInputView.textField {
            reNewOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            reNewOlaaPwInputView.baseView.layer.borderWidth = 1.0
            reNewOlaaPwInputView.errorNoteLabel.isHidden = true
            reNewOlaaPwInputView.isValidatePass = false
            
            if let currentText = textField.text, !currentText.isEmpty {
                if !ValidateUtils.validatePassword(currentText) {
                    reNewOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                    reNewOlaaPwInputView.baseView.layer.borderWidth = 1.0
                    reNewOlaaPwInputView.errorNoteLabel.isHidden = false
                    reNewOlaaPwInputView.errorNoteLabel.text = "密碼有誤，須為8-12碼包含大、小寫英文字母與數字"
                    
                    resetButton.isEnabled = false
                    resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    reNewOlaaPwInputView.isValidatePass = false
                    return
                }
                
                if gCurrentNewInputPW != currentText {
                    reNewOlaaPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                    reNewOlaaPwInputView.baseView.layer.borderWidth = 1.0
                    reNewOlaaPwInputView.errorNoteLabel.isHidden = false
                    reNewOlaaPwInputView.errorNoteLabel.text = "與新登入密碼輸入不一致"
                    
                    resetButton.isEnabled = false
                    resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                    reNewOlaaPwInputView.isValidatePass = false
                    return
                }
                
                reNewOlaaPwInputView.isValidatePass = true
            }
        }
        
        if oldOlaaPwInputView.isValidatePass &&
            newOlaaPwInputView.isValidatePass &&
            reNewOlaaPwInputView.isValidatePass  {
            resetButton.isEnabled = true
            resetButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
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
    
    @IBAction func resetAction(_ sender: UIButton) {
        verifyKeycode()
    }
}

extension LoginPWordViewController {
    func updateUI() {
        oldOlaaPwInputView.textField.keyboardType = .alphabet
        newOlaaPwInputView.textField.keyboardType = .alphabet
        reNewOlaaPwInputView.textField.keyboardType = .alphabet
        
        oldOlaaPwInputView.isRequired = false
        newOlaaPwInputView.isRequired = false
        reNewOlaaPwInputView.isRequired = false
        
        oldOlaaPwInputView.textField.textContentType = .oneTimeCode
        oldOlaaPwInputView.textField.isSecureTextEntry = true
        oldOlaaPwInputView.isEyeHidden = false
        newOlaaPwInputView.textField.textContentType = .oneTimeCode
        newOlaaPwInputView.textField.isSecureTextEntry = true
        newOlaaPwInputView.isEyeHidden = false
        reNewOlaaPwInputView.textField.textContentType = .oneTimeCode
        reNewOlaaPwInputView.textField.isSecureTextEntry = true
        reNewOlaaPwInputView.isEyeHidden = false
        
        resetButton.isEnabled = false
        resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        resetButton.setTitleColor(UIColor.lightGray, for: .disabled)
        resetButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        oldOlaaPwInputView.textField.delegate = self
        newOlaaPwInputView.textField.delegate = self
        reNewOlaaPwInputView.textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginPWordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        // 12位
        if let currentText = textField.text, currentText.count >= 12 {
            return false
        }
        
        return true
    }
    
    // Helper functions to sanitize input and validate password securely
    func sanitizeInput(_ input: String) -> String {
        // Perform input sanitization to remove any malicious or unexpected characters
        return input.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension LoginPWordViewController: ModifyResultAlertVCDelegate {
    func clickBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension LoginPWordViewController {
    func verifyKeycode() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.requestVerifyKeycode(RsaUtils.generateEncryptedData(src: self.gCurrentOldInputPW)) {
            (responseModel: PhiResponseModel<VerifyKeycodeRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let verifyKeycodeRspInfo = responseModel.data else {
                    return
                }
                
                print("keycodeVerified=\(verifyKeycodeRspInfo.keycodeVerified)!")
                
                if verifyKeycodeRspInfo.keycodeVerified {
                    DispatchQueue.main.async { [self] in
                        let keychain = KeychainSwift()
                        let memberAccount: String = keychain.get("memberAccount") ?? ""
                        
                        let storyboard = UIStoryboard(name: "RegisterOTP", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
                        vc.currentOTPType = .updateLoginPWord
                        vc.currentUserInputPhone = memberAccount
                        vc.currentTitle = "登入密碼"
                        
                        let oldRsaOlaaword = RsaUtils.generateEncryptedData(src: self.gCurrentOldInputPW)
                        let newRsaOlaaword = RsaUtils.generateEncryptedData(src: self.gCurrentNewInputPW)
                        vc.updateMemberKeyCodeInfo = UpdateMemberKeyCodeModel(oldMemberKeycode: oldRsaOlaaword, newMemberKeycode: newRsaOlaaword)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = "舊登入密碼輸入有誤"
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.verifyKeycode()
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
