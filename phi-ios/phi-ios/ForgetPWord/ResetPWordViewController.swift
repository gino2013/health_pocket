//
//  ResetPWordViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/26.
//

import UIKit
import ProgressHUD
import KeychainSwift

class ResetPWordViewController: BaseViewController {
    
    @IBOutlet weak var firstQeIptView: RgterInputView!
    @IBOutlet weak var reIptFirstQeIptView: RgterInputView!
    @IBOutlet weak var resetButton: UIButton!
    
    var gCurrentAccount: String = ""
    var gCurrentInputPW: String = ""
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        
        // 綁定 firstQeIptView 當編輯結束時觸發
        firstQeIptView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 reIptFirstQeIptView 當編輯結束時觸發
        reIptFirstQeIptView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == firstQeIptView.textField {
            firstQeIptView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            firstQeIptView.baseView.layer.borderWidth = 1.0
            firstQeIptView.errorNoteLabel.isHidden = true
            firstQeIptView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                // validate password
                if let currentText = textField.text {
                    if !ValidateUtils.validatePassword(currentText) {
                        firstQeIptView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        firstQeIptView.baseView.layer.borderWidth = 1.0
                        firstQeIptView.errorNoteLabel.isHidden = false
                        
                        resetButton.isEnabled = false
                        resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        firstQeIptView.isValidatePass = false
                        return
                    }
                    
                    // save password
                    gCurrentInputPW = currentText
                    
                    firstQeIptView.isValidatePass = true
                }
            }
            
        } else if textField == reIptFirstQeIptView.textField {
            reIptFirstQeIptView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            reIptFirstQeIptView.baseView.layer.borderWidth = 1.0
            reIptFirstQeIptView.errorNoteLabel.isHidden = true
            reIptFirstQeIptView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.validatePassword(currentText) {
                        // validate reIptFirstQeIptView
                        reIptFirstQeIptView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        reIptFirstQeIptView.baseView.layer.borderWidth = 1.0
                        reIptFirstQeIptView.errorNoteLabel.isHidden = false
                        reIptFirstQeIptView.errorNoteLabel.text = "密碼有誤，須為8-12碼包含大、小寫英文字母與數字"
                        
                        resetButton.isEnabled = false
                        resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        reIptFirstQeIptView.isValidatePass = false
                        return
                    }
                    
                    if gCurrentInputPW != currentText {
                        reIptFirstQeIptView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        reIptFirstQeIptView.baseView.layer.borderWidth = 1.0
                        reIptFirstQeIptView.errorNoteLabel.isHidden = false
                        reIptFirstQeIptView.errorNoteLabel.text = "密碼與確認密碼不符，請重新輸入。"
                        
                        resetButton.isEnabled = false
                        resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        reIptFirstQeIptView.isValidatePass = false
                        return
                    }
                    
                    reIptFirstQeIptView.isValidatePass = true
                }
            }
            
        }
        
        if firstQeIptView.isValidatePass && reIptFirstQeIptView.isValidatePass {
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
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
        sendResetMemberKeyCode(account: gCurrentAccount)
    }
}

extension ResetPWordViewController {
    func updateUI() {
        firstQeIptView.textField.keyboardType = .alphabet
        reIptFirstQeIptView.textField.keyboardType = .alphabet
        
        firstQeIptView.isRequired = false
        reIptFirstQeIptView.isRequired = false
        
        firstQeIptView.textField.textContentType = .oneTimeCode
        firstQeIptView.textField.isSecureTextEntry = true
        firstQeIptView.isEyeHidden = false
        reIptFirstQeIptView.textField.textContentType = .oneTimeCode
        reIptFirstQeIptView.textField.isSecureTextEntry = true
        reIptFirstQeIptView.isEyeHidden = false
        
        resetButton.isEnabled = false
        resetButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        resetButton.setTitleColor(UIColor.lightGray, for: .disabled)
        resetButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        firstQeIptView.textField.delegate = self
        reIptFirstQeIptView.textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ResetPWordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == firstQeIptView.textField || 
            textField == reIptFirstQeIptView.textField {
            // 12位
            if let currentText = textField.text, currentText.count >= 12 {
                return false
            }
        }
        
        return true
    }
}

extension ResetPWordViewController: ModifyResultAlertVCDelegate {
    func clickBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ResetPWordViewController {
    func sendResetMemberKeyCode(account: String) {
        let rsaOlaaword = RsaUtils.generateEncryptedData(src: gCurrentInputPW)
        
        let resetKeyCodeReqInfo: ResetMemberKeyCodeModel = ResetMemberKeyCodeModel(memberAccount: account, memberKeycode: rsaOlaaword)
        
        SDKManager.sdk.requestResetMemberKeyCode(resetKeyCodeReqInfo) {
            (responseModel: PhiResponseModel<StringModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                UserDefaults.standard.setIsFirstLogin(value: true)
                UserDefaults.standard.setEnableFaceId(value: false)
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "ModifyResultAlertVC") as! ModifyResultAlertVC
                    alertViewController.delegate = self
                    self.present(alertViewController, animated: true, completion: nil)
                }
               
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendResetMemberKeyCode(account: account)
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
