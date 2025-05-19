//
//  RegisterViewController.swift
//  Startup
//
//  Created by Kenneth on 2023/10/04.
//

import UIKit
import ProgressHUD
import KeychainSwift

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var svvpimyItView: RgterInputView!
    @IBOutlet weak var firstPwInputView: RgterInputView!
    @IBOutlet weak var reInputFirstPwInputView: RgterInputView!
    @IBOutlet weak var userIdInputView: RgterInputView!
    @IBOutlet weak var notyjfsuItView: RgterInputView!
    @IBOutlet weak var rzsoaItView: RgterInputView!
    @IBOutlet weak var selectPrivacyView: SelectPrivacy!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var gIsCheckBoxEnable: Bool = false
    var gCurrentInputPW: String = ""
    
    var timer: Timer?
    var status: String?
    var counter = 0.0
    let textShort = "註冊中，請稍候..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "註冊PHI"
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        
        // 綁定 svvpimyItView 當編輯結束時觸發
        svvpimyItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 firstPwInputView 當編輯結束時觸發
        firstPwInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 reInputFirstPwInputView 當編輯結束時觸發
        reInputFirstPwInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 userIdInputView 當編輯結束時觸發
        userIdInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 notyjfsuItView 當編輯結束時觸發
        notyjfsuItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 rzsoaItView 當編輯結束時觸發
        rzsoaItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
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
                    //if currentText.count != 10 {
                    if !ValidateUtils.isValidatePhoneNumber(currentText) {
                        svvpimyItView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        svvpimyItView.baseView.layer.borderWidth = 1.0
                        svvpimyItView.errorNoteLabel.isHidden = false
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        svvpimyItView.isValidatePass = false
                        return
                    }
                    
                    svvpimyItView.isValidatePass = true
                }
            }
            
        } else if textField == firstPwInputView.textField {
            firstPwInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            firstPwInputView.baseView.layer.borderWidth = 1.0
            firstPwInputView.errorNoteLabel.isHidden = true
            firstPwInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                // validate password
                if let currentText = textField.text {
                    // save password
                    gCurrentInputPW = currentText
                    
                    if !ValidateUtils.validatePassword(currentText) {
                        firstPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        firstPwInputView.baseView.layer.borderWidth = 1.0
                        firstPwInputView.errorNoteLabel.isHidden = false
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        firstPwInputView.isValidatePass = false
                        return
                    }
                    
                    firstPwInputView.isValidatePass = true
                }
            }
            
        } else if textField == reInputFirstPwInputView.textField {
            reInputFirstPwInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            reInputFirstPwInputView.baseView.layer.borderWidth = 1.0
            reInputFirstPwInputView.errorNoteLabel.isHidden = true
            reInputFirstPwInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.validatePassword(currentText) {
                        // validate reInputFirstPw
                        reInputFirstPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        reInputFirstPwInputView.baseView.layer.borderWidth = 1.0
                        reInputFirstPwInputView.errorNoteLabel.isHidden = false
                        reInputFirstPwInputView.errorNoteLabel.text = "密碼有誤，須為8-12碼包含大、小寫英文字母與數字"
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        reInputFirstPwInputView.isValidatePass = false
                        return
                    }
                    
                    if gCurrentInputPW != currentText {
                        reInputFirstPwInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        reInputFirstPwInputView.baseView.layer.borderWidth = 1.0
                        reInputFirstPwInputView.errorNoteLabel.isHidden = false
                        reInputFirstPwInputView.errorNoteLabel.text = "密碼與確認密碼不符，請重新輸入。"
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        reInputFirstPwInputView.isValidatePass = false
                        return
                    }
                    
                    reInputFirstPwInputView.isValidatePass = true
                }
            }
            
        } else if textField == userIdInputView.textField {
            userIdInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            userIdInputView.baseView.layer.borderWidth = 1.0
            userIdInputView.errorNoteLabel.isHidden = true
            userIdInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.isValidateIDNumberEnu(idNumber: currentText) {
                        // validate userId
                        userIdInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        userIdInputView.baseView.layer.borderWidth = 1.0
                        userIdInputView.errorNoteLabel.isHidden = false
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        userIdInputView.isValidatePass = false
                        return
                    }
                    
                    userIdInputView.isValidatePass = true
                }
            }
            
        } else if textField == notyjfsuItView.textField {
            notyjfsuItView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            notyjfsuItView.baseView.layer.borderWidth = 1.0
            notyjfsuItView.errorNoteLabel.isHidden = true
            notyjfsuItView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.validateBirthday(currentText).0 {
                        // validate birthday
                        notyjfsuItView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        notyjfsuItView.baseView.layer.borderWidth = 1.0
                        notyjfsuItView.errorNoteLabel.isHidden = false
                        notyjfsuItView.errorNoteLabel.text = ValidateUtils.validateBirthday(currentText).1
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        notyjfsuItView.isValidatePass = false
                        return
                    }
                    
                    notyjfsuItView.isValidatePass = true
                }
            }
            
        } else if textField == rzsoaItView.textField {
            rzsoaItView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            rzsoaItView.baseView.layer.borderWidth = 1.0
            rzsoaItView.errorNoteLabel.isHidden = true
            rzsoaItView.isValidatePass = true
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.isValidEmail(currentText) {
                        // validate email
                        rzsoaItView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        rzsoaItView.baseView.layer.borderWidth = 1.0
                        rzsoaItView.errorNoteLabel.isHidden = false
                        
                        registerButton.isEnabled = false
                        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        rzsoaItView.isValidatePass = false
                        return
                    }
                    
                    rzsoaItView.isValidatePass = true
                }
            }
        }
        
        if svvpimyItView.isValidatePass && firstPwInputView.isValidatePass && reInputFirstPwInputView.isValidatePass && userIdInputView.isValidatePass && notyjfsuItView.isValidatePass && rzsoaItView.isValidatePass && self.gIsCheckBoxEnable {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
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
        svvpimyItView.textField.keyboardType = .numberPad
        svvpimyItView.textField.isSecureTextEntry = false
        firstPwInputView.textField.keyboardType = .alphabet
        reInputFirstPwInputView.textField.keyboardType = .alphabet
        userIdInputView.textField.keyboardType = .asciiCapable
        userIdInputView.textField.isSecureTextEntry = false
        notyjfsuItView.textField.keyboardType = .numberPad
        notyjfsuItView.textField.isSecureTextEntry = false
        rzsoaItView.textField.keyboardType = .emailAddress
        rzsoaItView.textField.isSecureTextEntry = false
        
        firstPwInputView.textField.textContentType = .oneTimeCode
        firstPwInputView.textField.isSecureTextEntry = true
        firstPwInputView.isEyeHidden = false
        reInputFirstPwInputView.textField.textContentType = .oneTimeCode
        reInputFirstPwInputView.textField.isSecureTextEntry = true
        reInputFirstPwInputView.isEyeHidden = false
        
        rzsoaItView.isRequired = false
        rzsoaItView.isValidatePass = true
        
        selectPrivacyView.delegate = self
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        registerButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        registerButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        svvpimyItView.textField.delegate = self
        firstPwInputView.textField.delegate = self
        reInputFirstPwInputView.textField.delegate = self
        userIdInputView.textField.delegate = self
        notyjfsuItView.textField.delegate = self
        rzsoaItView.textField.delegate = self
        
        svvpimyItView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        firstPwInputView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        reInputFirstPwInputView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        userIdInputView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        notyjfsuItView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        rzsoaItView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    @objc func handleTextChange(_ textField: UITextField) {
        if textField != rzsoaItView.textField {
            if let currentText = textField.text {
                if currentText.isEmpty {
                    registerButton.isEnabled = false
                    registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                }
            }
        }
    }
    
    // 隱藏鍵盤，如果點擊了文字方塊以外的區域
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Note: account is mobile number
        guard let _ = svvpimyItView.textField.text,
              let _ = firstPwInputView.textField.text,
              let _ = reInputFirstPwInputView.textField.text,
              let _ = userIdInputView.textField.text,
              let _ = notyjfsuItView.textField.text,
              let _ = rzsoaItView.textField.text else {
            print("Warning! Handle missing fields!")
            return
        }
        
        processEndEditing(svvpimyItView.textField)
        processEndEditing(firstPwInputView.textField)
        processEndEditing(reInputFirstPwInputView.textField)
        processEndEditing(userIdInputView.textField)
        processEndEditing(notyjfsuItView.textField)
        processEndEditing(rzsoaItView.textField)
        
        if svvpimyItView.isValidatePass && firstPwInputView.isValidatePass && reInputFirstPwInputView.isValidatePass && userIdInputView.isValidatePass && notyjfsuItView.isValidatePass && rzsoaItView.isValidatePass && self.gIsCheckBoxEnable {
            
            // push to OTP view, after pass OTP then call register API
            let storyboard = UIStoryboard(name: "RegisterOTP", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
            vc.currentOTPType = .register
            
            let rsaMemberKeycode = RsaUtils.generateEncryptedData(src: firstPwInputView.textField.text ?? "")
            let postModel = RegisterModel(
                mobileUuid: KeychainSwift().get("uuid") ?? "",
                memberAccount: svvpimyItView.textField.text ?? "",
                memberKeycode: rsaMemberKeycode,
                officialNumber: userIdInputView.textField.text ?? "",
                birthDate: notyjfsuItView.textField.text ?? "",
                email: rzsoaItView.textField.text ?? "",
                hasBindingTOTP: false)
            vc.registerInfo = postModel
            vc.currentUserInputPhone = svvpimyItView.textField.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RegisterViewController: SelectPrivacyDelegate {
    func checkBoxStatus(isSelect: Bool) {
        self.gIsCheckBoxEnable = isSelect
        
        print("gIsCheckBoxEnable = \(gIsCheckBoxEnable)")
        
        if svvpimyItView.isValidatePass && firstPwInputView.isValidatePass && reInputFirstPwInputView.isValidatePass && userIdInputView.isValidatePass && notyjfsuItView.isValidatePass && rzsoaItView.isValidatePass && self.gIsCheckBoxEnable {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        }
    }
    
    func presetPrivacyPolicy(sender: UIButton) {
        let storyboard = UIStoryboard(name: "PrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension RegisterViewController {
    static func instance() -> RegisterViewController {
        let viewController = RegisterViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == notyjfsuItView.textField {
            // 超過8位，不允許輸入，加上2個/
            if let currentText = textField.text, currentText.count >= 10 {
                return false
            }
            
            if !ValidateUtils.checkIfNumber(src: string) {
                return false
            }
            
            /// 如果輸入的是第5個或第8個字符，自動在後面加上"/"
            if textField.text?.count == 4 || textField.text?.count == 7 {
                textField.text?.append("/")
            }
        } else if textField == svvpimyItView.textField {
            // 10位
            if let currentText = textField.text, currentText.count >= 10 {
                return false
            }
        } else if textField == firstPwInputView.textField || textField == reInputFirstPwInputView.textField {
            // 12位
            if let currentText = textField.text, currentText.count >= 12 {
                return false
            }
        } else if textField == userIdInputView.textField {
            guard let text = textField.text else { return true }
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            
            // 如果輸入第一個字元是小寫字母，則換成大寫
            if range.location == 0 && string.rangeOfCharacter(from: .lowercaseLetters) != nil {
                textField.text = newText.uppercased()
                return false
            }
            
            // 判斷輸入的字元是否為英文或數字
            let isEnglishOrNumber = string.rangeOfCharacter(from: .alphanumerics) != nil
            // 如果輸入的字元不是英文或數字，則不允許顯示
            if !isEnglishOrNumber {
                return false
            }
            
            if let currentText = textField.text, currentText.count >= 10 {
                return false
            }
        }
        
        return true
    }
}

extension RegisterViewController {
    //progressStart(textShort)
    //ProgressHUD.animate(textShort, interaction: false);
    //status = textShort
    
    func progressStart(_ status: String? = nil) {
        counter = 0
        ProgressHUD.progress(status, counter/100, interaction: false)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.progressStep(status)
        }
    }
    
    func progressStep(_ status: String?) {
        counter += 1
        ProgressHUD.progress(status, counter/100, interaction: false)
        
        if (counter >= 100) {
            progressStop(status)
        }
    }
    
    func progressStop(_ status: String?) {
        timer?.invalidate()
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            ProgressHUD.succeed("註冊成功！", interaction: false, delay: 0.75)
        }
    }
}
