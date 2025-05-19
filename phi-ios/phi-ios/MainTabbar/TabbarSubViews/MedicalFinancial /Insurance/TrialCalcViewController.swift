//
//  TrialCalcViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/18.
//

import UIKit
import ProgressHUD
import KeychainSwift

class TrialCalcViewController: BaseViewController {
    
    @IBOutlet weak var diagnosisContentInputView: InsuranceInputView!
    @IBOutlet weak var dOBInputView: RgterInputView!
    @IBOutlet weak var genderInputView: GenderRadioView!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentDiagnosisInfos: [String] = []
    var isKeyboardShowing: Bool = false
    var retryExecuted: Bool = false
    var currentSelectDisease: String = ""
    var currentBirthday: String = ""
    var currentGender: Gender = .F
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "理賠試算"
        replaceBackBarButtonItem()
        updateUI()
        configTextFieldDelegate()
        //useUserInfoUpdateUI()
        
        // 綁定 dOBInputView 當編輯結束時觸發
        dOBInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        
        // 綁定 diagnosisContentInputView 當編輯結束時觸發
        diagnosisContentInputView.textField.addTarget(self, action: #selector(processEndEditing(_:)), for: .editingDidEnd)
        
    
        getJWTToken(username: "cathayholdings", olaaword: "bjajymf2vo")
        
        // 監聽鍵盤隱藏
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        */
    }
    
    @objc func processEndEditing(_ textField: UITextField) {
        if textField == dOBInputView.textField {
            dOBInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            dOBInputView.baseView.layer.borderWidth = 1.0
            dOBInputView.errorNoteLabel.isHidden = true
            dOBInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                if let currentText = textField.text {
                    if !ValidateUtils.validateBirthday(currentText).0 {
                        // validate birthday
                        dOBInputView.baseView.layer.borderColor = UIColor(hex: "#F7453F", alpha: 1)?.cgColor
                        dOBInputView.baseView.layer.borderWidth = 1.0
                        dOBInputView.errorNoteLabel.isHidden = false
                        dOBInputView.errorNoteLabel.text = ValidateUtils.validateBirthday(currentText, isInsurance: true).1
                        
                        saveButton.isEnabled = false
                        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
                        dOBInputView.isValidatePass = false
                        return
                    }
                    
                    dOBInputView.isValidatePass = true
                    currentBirthday = dOBInputView.textField.text!
                }
            }
        } else if textField == diagnosisContentInputView.textField {
            diagnosisContentInputView.baseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)?.cgColor
            diagnosisContentInputView.baseView.layer.borderWidth = 1.0
            diagnosisContentInputView.errorNoteLabel.isHidden = true
            diagnosisContentInputView.isValidatePass = false
            
            if !(textField.text ?? "").isEmpty {
                diagnosisContentInputView.isValidatePass = true
            }
        }
        
        if dOBInputView.isValidatePass && diagnosisContentInputView.isValidatePass {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1.0)
        }
    }
    
    /*
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    */
    
    /*
    @objc func keyboardDidHide() {
        isKeyboardShowing = false
    }
    */
    
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
        dOBInputView.textField.keyboardType = .numberPad
        dOBInputView.textField.isSecureTextEntry = false
        dOBInputView.isEditable = true
        dOBInputView.isValidatePass = false
        
        // enable select view
        diagnosisContentInputView.textField.keyboardType = .default
        diagnosisContentInputView.isValidatePass = false
        diagnosisContentInputView.currentInputType = .diagnosisContent
        diagnosisContentInputView.enableSelectFunction = true
        
        // Remove *
        dOBInputView.isRequired = true
        diagnosisContentInputView.isRequired = true
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
        saveButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
        saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func configTextFieldDelegate() {
        diagnosisContentInputView.textField.delegate = self
        dOBInputView.textField.delegate = self
        genderInputView.delegate = self
        diagnosisContentInputView.delegate = self
        
        //dOBInputView.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    func useUserInfoUpdateUI() {
        // 匯入用戶資料
        if let userInfo = PHISDK_AllResponseData.sharedInstance.userInfo {
            dOBInputView.textField.text = userInfo.birthDate
        }
    }
    
    // 隱藏鍵盤，如果點擊了文字方塊以外的區域
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        processEndEditing(dOBInputView.textField)
        processEndEditing(diagnosisContentInputView.textField)
        
        if dOBInputView.isValidatePass && diagnosisContentInputView.isValidatePass {
            let storyboard = UIStoryboard(name: "InsurancePolicy", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InsurancePolicyInfoListVC") as! InsurancePolicyInfoListVC
            vc.diseaseName = currentSelectDisease
            vc.gender = currentGender.apiParameter
            vc.birthday = currentBirthday
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TrialCalcViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == dOBInputView.textField {
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
        }
        
        return true
    }
    
    func textFieldDidChange() {
        processEndEditing(diagnosisContentInputView.textField)
    }
}

extension TrialCalcViewController: InsuranceInputViewDelegate {
    func showDiagnosisSelectView() {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SelectContent", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectContentVC") as! SelectContentVC
        vc.viewTitle = "診斷內容"
        vc.itemArray = self.currentDiagnosisInfos
        vc.onSaveItem = { (item: String) -> () in
            self.currentSelectDisease = item
            
            DispatchQueue.main.async { [self] in
                self.diagnosisContentInputView.textField.text = self.currentSelectDisease
                self.textFieldDidChange()
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
}

extension TrialCalcViewController {
    static func instance() -> TrialCalcViewController {
        let viewController = TrialCalcViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension TrialCalcViewController {
    func getJWTToken(username: String, olaaword: String) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let requestInfo: GetJwtTokenModel = GetJwtTokenModel(memberAccount: username, memberKeycode: olaaword)
        
        SDKManager.ezclaimSdk.login4JwtSignin(requestInfo) {
            (responseModel: EzclaimRspModel<JwtTokenRspModel>) in
            
            if responseModel.success {
                guard let rspInfoArray = responseModel.data else {
                    return
                }
                
                for rspInfo in rspInfoArray {
                    print("rspInfo=\(rspInfo.token)!")
                    
                    let keychain = KeychainSwift()
                    keychain.set(rspInfo.token, forKey: "BearerToken")
                }
                
                DispatchQueue.main.async {
                    //self.diseaseClaimReport()
                    self.getDiseaseclaimconfig()
                    //self.getInsuranceproduct()
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
        }
    }
    
    func getDiseaseclaimconfig() {
        SDKManager.ezclaimSdk.diseaseclaimconfig() {
            (responseModel: EzclaimRspModel<DiseaseclaimRspModel>) in
            
            if responseModel.success {
                guard let rspInfoArray = responseModel.data, let _ = rspInfoArray.first else {
                    return
                }
                
                if rspInfoArray.count > 0 {
                    self.currentDiagnosisInfos.removeAll()
                    
                    // 遍歷數組並處理每個疾病信息
                    for rspInfo in rspInfoArray {
                        print("Disease Name: \(rspInfo.diseaseName)")
                        //print("Remark: \(rspInfo.remark)")
                        
                        self.currentDiagnosisInfos.append(rspInfo.diseaseName)
                    }
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
            
            ProgressHUD.dismiss()
        }
    }
    
    func getInsuranceproduct() {
        SDKManager.ezclaimSdk.insuranceproductSimple() {
            (responseModel: EzclaimRspModel<InsuranceProductRspModel>) in
            
            if responseModel.success {
                guard let rspInfoArray = responseModel.data, let _ = rspInfoArray.first else {
                    return
                }
                
                // 遍歷數組並處理每個疾病信息
                for rspInfo in rspInfoArray {
                    print("Product Code: \(rspInfo.productCode)")
                    print("Product Name: \(rspInfo.productName)")
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
            
            ProgressHUD.dismiss()
        }
    }
}

extension TrialCalcViewController: GenderRadioViewDelegate {
    func selectedStatus(selectGender: Gender) {
        currentGender = selectGender
    }
}
