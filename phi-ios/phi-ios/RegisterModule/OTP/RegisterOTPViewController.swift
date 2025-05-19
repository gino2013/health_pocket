//
//  RegisterOTPViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/18.
//

import UIKit
import ProgressHUD
import KeychainSwift

protocol RegisterOTPViewControllerDelegate: AnyObject {
    func otpPassThenGoToAddCryptoBankView(passCode: String)
    // func attemptExceededThenGoToCS()
}

class RegisterOTPViewController: BaseViewController {
    
    @IBOutlet weak var secondMainNoteLabel: UILabel!
    @IBOutlet weak var secondSubNoteLabel: UILabel!
    @IBOutlet weak var firstTextField: TextFieldWithoutPaste!
    @IBOutlet weak var secondTextField: TextFieldWithoutPaste!
    @IBOutlet weak var thirdTextField: TextFieldWithoutPaste!
    @IBOutlet weak var fourthTextField: TextFieldWithoutPaste!
    @IBOutlet weak var fifthTextField: TextFieldWithoutPaste!
    @IBOutlet weak var sixthTextField: TextFieldWithoutPaste!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var countDownView: UIView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var phoneDisplayLabel: UILabel!
    
    @IBAction func tapSendSMSButton(_ sender: UIButton) {
        callSendSMSApi()
    }
    
    @IBAction func verifyAction(_ sender: UIButton) {
        if currentOTPType == .register {
            if let registerInfo = self.registerInfo {
                if registerInfo.hasBindingTOTP {
                    ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
                    ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
                    ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
                    //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
                    self.getKeycloakToken()
                } else {
                    callVerifyPhoneApi()
                }
            }
        } else {
            callVerifyPhoneApi()
        }
    }
    
    weak var delegate: RegisterOTPViewControllerDelegate?
    //var phoneNumberForDisplay: String = ""
    var countdownTimer: CountdownTimer!
    var validationCode: ValidationCode = ValidationCode(first: "",
                                                        second: "",
                                                        third: "",
                                                        fourth: "",
                                                        fifth: "",
                                                        sixth: "")
    var testCount: Int = 0
    // var attempts: Int = 0
    var currentUserInputPhone: String = ""
    // For Firebase OTP Test phone
    let phoneNumber = "+16505551111"
    var currentOTPType: OTP_Type = .register
    //var registerInfo: RegisterModel?
    var registerInfo: RegisterModel?
    var updateMemberKeyCodeInfo: UpdateMemberKeyCodeModel?
    var idToken: String = ""
    var retryExecuted: Bool = false
    var currentTitle: String = "註冊PHI"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        settingSixInputTextField()
        processCheckContinueCountDown()
        // Note: Start to send SMS API then UI countdown
        callSendSMSApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearShadow()
        
        let maskedPhoneNumber = maskPhoneNumber(currentUserInputPhone)
        phoneDisplayLabel.text = maskedPhoneNumber
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = currentTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // check if dealloc countdownTimer
        if countdownTimer != nil {
            countdownTimer.isFinish(isVerifySuccess: false)
        }
    }
    
    func processCheckContinueCountDown() {
        guard let startVerifyDate = UserDefaults.standard.getStartOTPVerifySMSTime() else { return }
        
        let toDate: Date = Date()
        let second = toDate.countSeconds(from: startVerifyDate)
        
        if (second - 90) >= 0 {
            UserDefaults.standard.clearStartCryptoOTPVerifySMSTime()
        } else {
            // countinue countDown
            self.changeToCountDownUI(second: (90 - second))
        }
    }
    
    @objc override func popPresentedViewController() {
        if countdownTimer != nil {
            countdownTimer.end()
        }
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        if countdownTimer != nil {
            countdownTimer.end()
        }
    }
}

// Init. UI
extension RegisterOTPViewController {
    func settingSixInputTextField() {
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        sixthTextField.delegate = self
        
        firstTextField.backgroundColor = .white
        secondTextField.backgroundColor = .white
        thirdTextField.backgroundColor = .white
        fourthTextField.backgroundColor = .white
        fifthTextField.backgroundColor = .white
        sixthTextField.backgroundColor = .white
        
        firstTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        thirdTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        fourthTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        fifthTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        sixthTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        clearShadow()
    }
    
    func updateUI() {
        //if let userInfo = AllResponseData.sharedInstance.userInfo {
        //validationPhoneNumber = userInfo.mobile ?? ""
        //}
        //validationPhoneNumber = "0920123456"
        
        countDownView.isHidden = true
        sendSMSButton.isEnabled = true
        sendSMSButton.setTitle("發送", for: .normal)
        
        //secondMainNoteLabel.font = UIFont.fontWithSizeByScreenWidth(375, fontSize: 14, source: secondMainNoteLabel.font)
        //secondSubNoteLabel.font = UIFont.systemFontOfSizeByScreenWidth(375, fontSize: 12)
        //warningNoteLabel.font = UIFont.systemFontOfSizeByScreenWidth(375, fontSize: 12)
        //tryNumberLabel.attributedText = createTryErrorAttributedString()
        
        verifyButton.isEnabled = true
    }
    
    func maskPhoneNumber(_ phoneNumber: String) -> String {
        guard phoneNumber.count >= 4 else { return phoneNumber }
        
        let startIndex = phoneNumber.startIndex
        let endIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -2)
        let prefix = phoneNumber[startIndex..<phoneNumber.index(startIndex, offsetBy: 2)]
        let suffix = phoneNumber[endIndex..<phoneNumber.endIndex]
        
        let maskedString = "\(prefix)******\(suffix)"
        return maskedString
    }
}
// UI
extension RegisterOTPViewController {
    func changeToCountDownUI(second: Int = 90) {
        sendSMSButton.isHidden = true
        countDownView.isHidden = false
        
        countDownLabel.text = "\(second)" + "秒 重新發送"
        
        if UserDefaults.standard.getStartOTPVerifySMSTime() == nil {
            // first verify, save current time
            UserDefaults.standard.setStartOTPVerifySMSTime(value: Date())
        }
        createCountdownTimer(second: second)
    }
    
    func updateTryNumberUI() {
        /*
         self.attempts = SharingManager.sharedInstance.checkIsAbleSMSOTPResponseData_Attempts
         self.tryNumberLabel.attributedText = self.createTryErrorAttributedString()
         */
    }
}

// Countdown
extension RegisterOTPViewController: CountdownTimerDelegate {
    func createCountdownTimer(second: Int) {
        let (h, m, s) = DateTimeUtils.secondsToHoursMinutesSeconds(seconds: second)
        
        countdownTimer = CountdownTimer(hours: (h), minutes: (m), seconds: (s))
        countdownTimer.delegate = self
        countdownTimer.start()
    }
    
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        let timeString: String = "\(time.hours):\(time.minutes):\(time.seconds)"
        
        countDownLabel.text = "\(timeString.secondFromString)" + "秒 重新發送"
    }
    
    // count down finish
    func countdownTimerFinish(isVerifySuccess: Bool?) {
        if let isVerifySuccess = isVerifySuccess, isVerifySuccess {
            UserDefaults.standard.clearStartCryptoOTPVerifySMSTime()
        }
        
        sendSMSButton.isHidden = false
        sendSMSButton.setTitle("重新發送", for: .normal)
        countDownView.isHidden = true
        
        // Updated try error number
        /*
         let callback: () -> Void = {
         DispatchQueue.main.async {
         self.updateTryNumberUI()
         }
         }
         */
        
        //checkIsAbleSMSOTP(pageName: self.pageNameKey,
        //                  requestCompleted: callback)
    }
}

// TextField Function
extension RegisterOTPViewController: UITextFieldDelegate {
    func checkEnableVerifyBtn() {
        guard
            firstTextField.text  != "",
            secondTextField.text != "",
            thirdTextField.text  != "",
            fourthTextField.text != "",
            fifthTextField.text  != "",
            sixthTextField.text  != ""
        else {
            //verifyButton.isEnabled = false
            return
        }
        
        //verifyButton.isEnabled = true
    }
    
    @objc func handleTextChange(_ textField: UITextField) {
        let text = textField.text
        
        if text?.count == 1 {
            switch textField {
            case firstTextField:
                validationCode.first = textField.text!
                secondTextField.becomeFirstResponder()
                
            case secondTextField:
                validationCode.second = textField.text!
                thirdTextField.becomeFirstResponder()
                
            case thirdTextField:
                validationCode.third = textField.text!
                fourthTextField.becomeFirstResponder()
                
            case fourthTextField:
                validationCode.fourth = textField.text!
                fifthTextField.becomeFirstResponder()
                
            case fifthTextField:
                validationCode.fifth = textField.text!
                sixthTextField.becomeFirstResponder()
                
            case sixthTextField:
                validationCode.sixth = textField.text!
                sixthTextField.resignFirstResponder()
                
            default:
                break
            }
        } else {
            
        }
        
        checkEnableVerifyBtn()
    }
    
    func clearShadow() {
        firstTextField.layer.shadowColor = UIColor.clear.cgColor
        secondTextField.layer.shadowColor = UIColor.clear.cgColor
        thirdTextField.layer.shadowColor = UIColor.clear.cgColor
        fourthTextField.layer.shadowColor = UIColor.clear.cgColor
        fifthTextField.layer.shadowColor = UIColor.clear.cgColor
        sixthTextField.layer.shadowColor = UIColor.clear.cgColor
        
        firstTextField.layer.borderColor = UIColor(hex: "#CDD0D2", alpha: 1)?.cgColor
        secondTextField.layer.borderColor = UIColor(hex: "#CDD0D2", alpha: 1)?.cgColor
        thirdTextField.layer.borderColor = UIColor(hex: "#CDD0D2", alpha: 1)?.cgColor
        fourthTextField.layer.borderColor = UIColor(hex: "#CDD0D2", alpha: 1)?.cgColor
        fifthTextField.layer.borderColor = UIColor(hex: "#CDD0D2", alpha: 1)?.cgColor
        sixthTextField.layer.borderColor = UIColor(hex: "#CDD0D2", alpha: 1)?.cgColor
    }
    
    func showWarningBorder() {
        firstTextField.layer.cornerRadius = 4
        firstTextField.layer.borderWidth = 1
        firstTextField.layer.borderColor = UIColor.systemRed.cgColor
        
        secondTextField.layer.cornerRadius = 4
        secondTextField.layer.borderWidth = 1
        secondTextField.layer.borderColor = UIColor.systemRed.cgColor
        
        thirdTextField.layer.cornerRadius = 4
        thirdTextField.layer.borderWidth = 1
        thirdTextField.layer.borderColor = UIColor.systemRed.cgColor
        
        fourthTextField.layer.cornerRadius = 4
        fourthTextField.layer.borderWidth = 1
        fourthTextField.layer.borderColor = UIColor.systemRed.cgColor
        
        fifthTextField.layer.cornerRadius = 4
        fifthTextField.layer.borderWidth = 1
        fifthTextField.layer.borderColor = UIColor.systemRed.cgColor
        
        sixthTextField.layer.cornerRadius = 4
        sixthTextField.layer.borderWidth = 1
        sixthTextField.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textFieldEditing(textField: textField)
        
        textField.text = ""
        
        switch textField {
        case firstTextField:
            validationCode.first = ""
        case secondTextField:
            validationCode.second = ""
        case thirdTextField:
            validationCode.third = ""
        case fourthTextField:
            validationCode.fourth = ""
        case fifthTextField:
            validationCode.fifth = ""
        case sixthTextField:
            validationCode.sixth = ""
        default:
            break
        }
        
        self.handleTextChange(textField)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.shadowColor = UIColor.clear.cgColor
        textField.textColor = UIColor.black
        return true
    }
    
    func textFieldEditing(textField: UITextField) {
        //self.warningNoteLabel.isHidden = true
        self.clearShadow()
        
        textField.layer.shadowColor = UIColor(hex: "#3399DB", alpha: 1.0)!.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowRadius = 0
        textField.layer.shadowOpacity = 1
        textField.textColor = .black
    }
}

// FunpodiumSDK APIs
extension RegisterOTPViewController {
    func callSendSMSApi() {
        AuthManager.shared.startAuth(phoneNumber: phoneNumber) { [weak self] success in
            guard success else { return }
            
            DispatchQueue.main.async {
                self?.changeToCountDownUI()
            }
        }
    }
    
    func callVerifyPhoneApi() {
        guard
            validationCode.first  != "",
            validationCode.second != "",
            validationCode.third  != "",
            validationCode.fourth != "",
            validationCode.fifth  != "",
            validationCode.sixth  != ""
        else {
            if validationCode.first == "" {
                self.textFieldEditing(textField: firstTextField)
                firstTextField.becomeFirstResponder()
            } else if validationCode.second == "" {
                self.textFieldEditing(textField: secondTextField)
                secondTextField.becomeFirstResponder()
            } else if validationCode.third == "" {
                self.textFieldEditing(textField: thirdTextField)
                thirdTextField.becomeFirstResponder()
            } else if validationCode.fourth == "" {
                self.textFieldEditing(textField: fourthTextField)
                fourthTextField.becomeFirstResponder()
            } else if validationCode.fifth == "" {
                self.textFieldEditing(textField: fifthTextField)
                fifthTextField.becomeFirstResponder()
            } else if validationCode.sixth == "" {
                self.textFieldEditing(textField: sixthTextField)
                sixthTextField.becomeFirstResponder()
            }
            return
        }
        
        let code = validationCode.first + validationCode.second + validationCode.third + validationCode.fourth + validationCode.fifth + validationCode.sixth
        
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            guard success else {
                DispatchQueue.main.async {
                    self?.showWarningBorder()
                    let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                    //alertViewController.delegate = self
                    alertViewController.alertLabel.text = "驗證碼輸入有誤"
                    alertViewController.alertImageView.image = UIImage(named: "Error")
                    self?.present(alertViewController, animated: true, completion: nil)
                }
                return
            }
            
            guard let self = self else { return }
            
            if self.currentOTPType == .changePWord {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "ResetPWord", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ResetPWordViewController") as! ResetPWordViewController
                    vc.gCurrentAccount = self.currentUserInputPhone
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if self.currentOTPType == .register {
                    self.registerInfo?.hasBindingTOTP = true
                    
                    DispatchQueue.main.async {
                        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
                        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
                        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
                        //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
                        self.getKeycloakToken()
                    }
                } else if self.currentOTPType == .updateLoginPWord {
                    DispatchQueue.main.async {
                        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
                        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
                        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
                        //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
                        self.sendUpdateMemberKeyCode()
                    }
                }
            }
        }
    }
}

extension RegisterOTPViewController: VerifyResultAlertVCDelegate {
    func clickBtn(alertType: VerifyResultAlertVC_Type) {
        if currentOTPType == .updateLoginPWord {
            if alertType == .updateMemberKeyCodeFail {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else if currentOTPType == .register {
            if alertType == .registerSuccess {
                self.navigationController?.popToRootViewController(animated: true)
            } else if alertType == .registerFail {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension RegisterOTPViewController {
    func getKeycloakToken() {
        let rsaKeyCode = RsaUtils.generateEncryptedData(src: CommonSettings.KeycloakCode)
        
        SDKManager.sdk.batchLogin(keycode: rsaKeyCode) {
            (responseModel: PhiResponseModel<BatchLoginRspModel>) in
            
            if responseModel.success {
                guard let batchLoginRspInfo = responseModel.data else {
                    return
                }

                print("idToken = \(batchLoginRspInfo.idToken)!")
                print("durationInSecond = \(batchLoginRspInfo.durationInSecond)!")
                
                self.idToken = batchLoginRspInfo.idToken
                
                DispatchQueue.main.async {
                    // only for register, no need save
                    // let keychain = KeychainSwift()
                    // keychain.set(self.idToken, forKey: "idToken")
                    self.sendRegister()
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getKeycloakToken()
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
    
    func sendRegister() {
        if let registerInfo = self.registerInfo {
            SDKManager.sdk.requestRegister(self.idToken, postModel: registerInfo) {
                (responseModel: PhiResponseModel<StringModel>) in
                
                ProgressHUD.dismiss()
                
                if responseModel.success {
                    guard let _ = responseModel.data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.delegate = self
                        alertViewController.alertType = .registerSuccess
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                   
                } else {
                    print("errorCode=\(responseModel.errorCode ?? "")!")
                    print("message=\(responseModel.message ?? "")!")
                    
                    self.handleAPIError(response: responseModel, retryAction: {
                        // 重試 API 呼叫
                        self.sendRegister()
                    }, fallbackAction: {
                        // 後備行動，例如顯示錯誤提示
                        DispatchQueue.main.async {
                            let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                            alertViewController.delegate = self
                            alertViewController.alertLabel.text = responseModel.message ?? ""
                            alertViewController.alertImageView.image = UIImage(named: "Error")
                            alertViewController.alertType = .registerFail
                            self.present(alertViewController, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func sendUpdateMemberKeyCode() {
        guard let updateMemberKeyCodeInfo = self.updateMemberKeyCodeInfo else {
            return
        }
        
        SDKManager.sdk.requestUpdateMemberKeyCode(updateMemberKeyCodeInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                UserDefaults.standard.setIsFirstLogin(value: true)
                UserDefaults.standard.setEnableFaceId(value: false)
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "FixedVerifyResultAlertVC") as! FixedVerifyResultAlertVC
                    alertViewController.delegate = self
                    alertViewController.alertLabel.text = "設定成功"
                    self.present(alertViewController, animated: true, completion: nil)
                }
               
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendUpdateMemberKeyCode()
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
