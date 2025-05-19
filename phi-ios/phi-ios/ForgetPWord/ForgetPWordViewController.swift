//
//  ForgetPWordViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/26.
//

import UIKit
import ProgressHUD

class ForgetPWordViewController: BaseViewController {
    
    @IBOutlet weak var svvpimyItView: RgterInputView!
    @IBOutlet weak var nextStepButton: UIButton!
    
    var userInputPhone: String = ""
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        
        // 綁定 svvpimyItView 當編輯結束時觸發
        svvpimyItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
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
                        
                        nextStepButton.isEnabled = false
                        nextStepButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        svvpimyItView.isValidatePass = false
                        return
                    }
                    
                    // save phone
                    userInputPhone = currentText
                    svvpimyItView.isValidatePass = true
                }
            }
        }
        
        if svvpimyItView.isValidatePass {
            nextStepButton.isEnabled = true
            nextStepButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
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
    
    @IBAction func clickNextStepAction(_ sender: UIButton) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        //ProgressHUD.animate(nil, .activityIndicator, interaction: false)
        sendCheckMembership(account: self.userInputPhone)
    }
}

extension ForgetPWordViewController {
    func updateUI() {
        svvpimyItView.textField.keyboardType = .numberPad
        svvpimyItView.textField.isSecureTextEntry = false
        svvpimyItView.isRequired = false
        nextStepButton.isEnabled = false
        nextStepButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        nextStepButton.setTitleColor(UIColor.lightGray, for: .disabled)
        nextStepButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        svvpimyItView.textField.delegate = self
        /*
        svvpimyItView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
         */
    }
    
    /*
    @objc func handleTextChange(_ textField: UITextField) {
        if textField != svvpimyItView.textField {
            if let currentText = textField.text {
                if currentText.isEmpty {
                    nextStepButton.isEnabled = false
                    nextStepButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                }
            }
        }
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ForgetPWordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == svvpimyItView.textField {
            // 10位
            if let currentText = textField.text, currentText.count >= 10 {
                return false
            }
        }
        
        return true
    }
}

extension ForgetPWordViewController {
    func sendCheckMembership(account: String) {
        let checkMembershipModelReqInfo: CheckMembershipModel = CheckMembershipModel(memberAccount: account)

        SDKManager.sdk.requestCheckMembership(checkMembershipModelReqInfo) {
            (responseModel: PhiResponseModel<CheckMembershipRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let checkMembershipRspInfo = responseModel.data else {
                    return
                }
                
                if checkMembershipRspInfo.isMember {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "RegisterOTP", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
                        vc.currentOTPType = .changePWord
                        vc.currentUserInputPhone = self.userInputPhone
                        vc.currentTitle = "忘記密碼"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = "帳號(手機號碼)不存在"
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendCheckMembership(account: account)
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
