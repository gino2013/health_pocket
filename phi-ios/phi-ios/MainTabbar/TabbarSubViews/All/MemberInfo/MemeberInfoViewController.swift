//
//  MemeberInfoViewController.swift
//  pho-ios
//
//  Created by Kenneth on 2024/4/2.
//

import UIKit
import ProgressHUD

enum Gender: String {
    case M = "男性"
    case F = "女性"
    
    var apiParameter: String {
        switch self {
        case .M:
            return "M"
        case .F:
            return "F"
        }
    }
}

class MemeberInfoViewController: BaseViewController {
    
    @IBOutlet weak var svvpimyItView: RgterInputView!
    @IBOutlet weak var mszrItView: RgterInputView!
    @IBOutlet weak var idrtofItView: RgterInputView!
    @IBOutlet weak var notyjfsuItView: RgterInputView!
    @IBOutlet weak var genderInputView: RgterInputView!
    @IBOutlet weak var rzsoaItView: RgterInputView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var currentGender: String = ""
    var isKeyboardShowing: Bool = false
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "會員資料"
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        useUserInfoUpdateUI()
        
        // 監聽鍵盤隱藏
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // 綁定 nameInputView 當編輯結束時觸發
        mszrItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        // 綁定 emailInputView 當編輯結束時觸發
        rzsoaItView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
    }
    
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == mszrItView.textField {
            mszrItView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            mszrItView.baseView.layer.borderWidth = 1.0
            mszrItView.errorNoteLabel.isHidden = true
            mszrItView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.isValidName(currentText) {
                        
                        mszrItView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        mszrItView.baseView.layer.borderWidth = 1.0
                        mszrItView.errorNoteLabel.isHidden = false
                        
                        saveButton.isEnabled = false
                        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        mszrItView.isValidatePass = false
                        return
                    }
                    
                    mszrItView.isValidatePass = true
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
                        
                        saveButton.isEnabled = false
                        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        rzsoaItView.isValidatePass = false
                        return
                    }
                    
                    rzsoaItView.isValidatePass = true
                }
            }
        }
        
        guard let nameText = mszrItView.textField.text,
              let genderText = genderInputView.textField.text,
              let emailText = rzsoaItView.textField.text else {
            print("Warning! Handle missing fields!")
            return
        }
        
        if nameText.isEmpty && genderText.isEmpty && emailText.isEmpty {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        } else if mszrItView.isValidatePass ||
                    rzsoaItView.isValidatePass ||
            genderInputView.isValidatePass {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidHide() {
        isKeyboardShowing = false
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
        svvpimyItView.isEditable = false
        svvpimyItView.isValidatePass = true
        svvpimyItView.textField.isSecureTextEntry = false
        
        idrtofItView.textField.keyboardType = .alphabet
        idrtofItView.isEditable = false
        idrtofItView.isValidatePass = true
        idrtofItView.textField.isSecureTextEntry = false
        
        notyjfsuItView.textField.keyboardType = .numberPad
        notyjfsuItView.isEditable = false
        notyjfsuItView.isValidatePass = true
        notyjfsuItView.textField.isSecureTextEntry = false
        
        genderInputView.textField.isSecureTextEntry = false
        
        mszrItView.textField.keyboardType = .default
        mszrItView.textField.isSecureTextEntry = false
        rzsoaItView.textField.keyboardType = .emailAddress
        rzsoaItView.textField.isSecureTextEntry = false
        
        // Remove *
        svvpimyItView.isRequired = false
        mszrItView.isRequired = false
        idrtofItView.isRequired = false
        notyjfsuItView.isRequired = false
        genderInputView.isRequired = false
        rzsoaItView.isRequired = false
        
        // enable gender select
        genderInputView.enableGenderSelectFunction = true
        genderInputView.delegate = self
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        cancelButton.layer.borderWidth = 1.0
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        saveButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        mszrItView.textField.delegate = self
        genderInputView.textField.delegate = self
        rzsoaItView.textField.delegate = self
        
        mszrItView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        rzsoaItView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    func useUserInfoUpdateUI() {
        if let userInfo = PHISDK_AllResponseData.sharedInstance.userInfo {
            idrtofItView.textField.text = userInfo.officialNumber
            svvpimyItView.textField.text = userInfo.memberAccount
            notyjfsuItView.textField.text = userInfo.birthDate
            
            if userInfo.name.isEmpty && userInfo.email.isEmpty && userInfo.gender.isEmpty {
                saveButton.isEnabled = false
                saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            } else {
                mszrItView.textField.text = userInfo.name
                rzsoaItView.textField.text = userInfo.email
                
                if userInfo.gender == Gender.F.apiParameter {
                    genderInputView.textField.text = Gender.F.rawValue
                } else if userInfo.gender == Gender.M.apiParameter {
                    genderInputView.textField.text = Gender.M.rawValue
                } else {
                    genderInputView.textField.text = ""
                }
                
                mszrItView.isValidatePass = true
                rzsoaItView.isValidatePass = true
                genderInputView.isValidatePass = true
                
                saveButton.isEnabled = true
                saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
            }
        }
    }
    
    @objc func handleTextChange(_ textField: UITextField) {
        /*
        if let nameText = nameInputView.textField.text {
            if !ValidateUtils.isValidName(nameText) {
                textField.text = String(nameText.dropLast())
            }
        }
        */
        
        if let nameText = mszrItView.textField.text,
           let emailText = rzsoaItView.textField.text,
           let genderText = genderInputView.textField.text {
            if nameText.isEmpty || emailText.isEmpty || genderText.isEmpty {
                saveButton.isEnabled = false
                saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            } else {
                saveButton.isEnabled = true
                saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
            }
        }
    }
    
    // 隱藏鍵盤，如果點擊了文字方塊以外的區域
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "是否確認修改？"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確定", for: .normal)
        alertViewController.alertType = .confirmEditProfile
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "是否取消編輯？"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確定", for: .normal)
        alertViewController.alertType = .cancelEditProfile
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension MemeberInfoViewController {
    static func instance() -> MemeberInfoViewController {
        let viewController = MemeberInfoViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension MemeberInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        /*
        if textField == nameInputView.textField {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return ValidateUtils.isValidName(newText)
        }
        */
        return true
    }
}

extension MemeberInfoViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        if alertType == .cancelEditProfile {
            // N/A
        } else if alertType == .confirmEditProfile {
            // N/A
        }
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .cancelEditProfile {
            self.navigationController?.popViewController(animated: true)
        } else if alertType == .confirmEditProfile {
            // Note: account is mobile number
            guard let nameText = mszrItView.textField.text,
                  let genderText = genderInputView.textField.text,
                  let emailText = rzsoaItView.textField.text else {
                print("Warning! Handle missing fields!")
                return
            }
            
            var genderData: Gender = .M
            
            if genderText == Gender.F.rawValue {
                genderData = .F
            }
            updateMember(name: nameText, email: emailText, gender: genderData.apiParameter)
        }
    }
}

extension MemeberInfoViewController: VerifyResultAlertVCDelegate {
    func clickBtn(alertType: VerifyResultAlertVC_Type) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MemeberInfoViewController: RgterInputViewDelegate {
    func showGenderSelectView() {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectSex", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectSexViewController") as! SelectSexViewController
        vc.onSaveGender = { (gender: String) -> () in
            self.currentGender = gender
            
            DispatchQueue.main.async { [self] in
                self.genderInputView.textField.text = self.currentGender
                self.genderInputView.isValidatePass = true
                self.processEndEditing(self.genderInputView.textField)
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
}

extension MemeberInfoViewController {
    func updateMember(name: String, email: String, gender: String) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let requestInfo: UpdateMemberInfoModel = UpdateMemberInfoModel(name: name, email: email, gender: gender)
        
        SDKManager.sdk.updateMemberInfo(requestInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                
                if PHISDK_AllResponseData.sharedInstance.userInfo != nil {
                    PHISDK_AllResponseData.sharedInstance.userInfo?.name = name
                    PHISDK_AllResponseData.sharedInstance.userInfo?.email = email
                    PHISDK_AllResponseData.sharedInstance.userInfo?.gender = gender
                }
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                    alertViewController.alertLabel.text = "修改成功"
                    alertViewController.delegate = self
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.updateMember(name: name, email: email, gender: gender)
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
