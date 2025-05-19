//
//  InputOlaaViewController.swift
//  pho-ios
//
//  Created by Kenneth on 2024/4/15.
//

import UIKit
import KeychainSwift

class InputOlaaViewController: BaseViewController {

    @IBOutlet weak var olaawordInputView: LoginInputView!
    @IBOutlet weak var sendButton: UIButton!
        
    var currentAuthType: AuthVerifyType = .loginOlaaword
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "授權認證"
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        
        // 綁定 olaawordInputView 當編輯結束時觸發
        olaawordInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    // checkmarx
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == olaawordInputView.textField {
            olaawordInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            olaawordInputView.baseView.layer.borderWidth = 1.0
            olaawordInputView.errorNoteLabel.isHidden = true
            olaawordInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                // validate password
                if let currentText = textField.text {
                    if !ValidateUtils.validatePassword(currentText) {
                        olaawordInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        olaawordInputView.baseView.layer.borderWidth = 1.0
                        olaawordInputView.errorNoteLabel.isHidden = false
                        
                        sendButton.isEnabled = false
                        sendButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        olaawordInputView.isValidatePass = false
                        return
                    }
                    
                    olaawordInputView.isValidatePass = true
                }
            }
        }
        
        if olaawordInputView.isValidatePass {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
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
        olaawordInputView.isRequired = false
        olaawordInputView.textField.keyboardType = .alphabet
        olaawordInputView.textField.isSecureTextEntry = true
        olaawordInputView.textField.clearsOnBeginEditing = true
        olaawordInputView.isEyeHidden = false
        olaawordInputView.isRememberMe = false
        olaawordInputView.isForgetPw = true
        olaawordInputView.delegate = self
        
        sendButton.isEnabled = false
        sendButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        sendButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        sendButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        olaawordInputView.textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        let keychain = KeychainSwift()
        let olaaword: String = keychain.get("olaaword") ?? ""
        
        if let currentText = olaawordInputView.textField.text {
            if currentText == olaaword {
                let storyboard = UIStoryboard(name: "AuthSetting", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AuthSettingStep1ViewController") as! AuthSettingStep1ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                olaawordInputView.textField.becomeFirstResponder()
                olaawordInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                olaawordInputView.baseView.layer.borderWidth = 1.0
                olaawordInputView.errorNoteLabel.isHidden = false
                olaawordInputView.errorNote = "密碼輸入有誤，請重新輸入"
                olaawordInputView.isValidatePass = false
                sendButton.isEnabled = false
                sendButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            }
        }
    }
}

extension InputOlaaViewController: LoginInputViewDelegate {
    func clickForgetPwThenPushView() {
        let storyboard = UIStoryboard(name: "ForgetPWord", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPWordViewController") as! ForgetPWordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkBoxStatus(isSelect: Bool) {
        print("isSelect = \(isSelect)!")
    }
}

extension InputOlaaViewController {
    static func instance() -> InputOlaaViewController {
        let viewController = InputOlaaViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension InputOlaaViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == olaawordInputView.textField {
            // 12位
            if let currentText = textField.text, currentText.count >= 12 {
                return false
            }
        }
        
        return true
    }
}
