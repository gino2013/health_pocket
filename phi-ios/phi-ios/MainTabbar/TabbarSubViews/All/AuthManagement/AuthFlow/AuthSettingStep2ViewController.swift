//
//  AuthSettingStep2ViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/4/16.
//

import UIKit
import ProgressHUD

class AuthSettingStep2ViewController: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var allAuthImageView: UIImageView!
    @IBOutlet weak var intervalAuthImageView: UIImageView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var startBaseView: UIView!
    @IBOutlet weak var endBaseView: UIView!
    
    @IBOutlet weak var step2ImageView: UIImageView!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3ImageView: UIImageView!
    @IBOutlet weak var step3Label: UILabel!
    
    var isSelectAll: Bool = true
    var currentStartDate: String = ""
    var currentEndDate: String = ""
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "授權資料設定"
        replaceBackBarButtonItem()
        updateUI()
        setItemView()
    }
    
    func updateUI() {
        itemListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        cancelButton.layer.borderWidth = 1.0
        
        /*
         sendButton.isEnabled = false
         sendButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
         sendButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
         sendButton.setTitleColor(UIColor.white, for: .normal)
         */
        
        //startDatePicker.locale = Locale(identifier: "zh_TW")
        //endDatePicker.locale = Locale(identifier: "zh_TW")
        
        startDatePicker.isEnabled = false
        endDatePicker.isEnabled = false
        startDatePicker.locale = Locale(identifier: "zh-Hant_TW")
        endDatePicker.locale = Locale(identifier: "zh-Hant_TW")
        
        startBaseView.layer.cornerRadius = 6
        startBaseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)!.cgColor
        startBaseView.layer.borderWidth = 1
        startBaseView.layer.masksToBounds = true
        
        endBaseView.layer.cornerRadius = 6
        endBaseView.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)!.cgColor
        endBaseView.layer.borderWidth = 1
        endBaseView.layer.masksToBounds = true
        
        // Image is too small
        /*
         allAuthImageView.isUserInteractionEnabled = true
         allAuthImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
         action: #selector(handleAllSelection)))
         intervalAuthImageView.isUserInteractionEnabled = true
         intervalAuthImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
         action: #selector(handleIntervalSelection)))
         */
    }
    
    func setItemView() {
        //
    }
    
    func confirmInputDateIsLegal() -> Bool {
        if DateTimeUtils.compareDatesByYearMonthDay(date1: self.endDatePicker.date, date2: self.startDatePicker.date) {
            return false
        } else {
            return true
        }
    }
    
    func convertStartDateToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let selectedDate = dateFormatter.string(from: self.startDatePicker.date)
        
        return selectedDate
    }
    
    func convertEndDateToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let selectedDate = dateFormatter.string(from: self.endDatePicker.date)
        
        return selectedDate
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        //let authHospital: String = "國泰醫院"
        //SharingManager.sharedInstance.authDoneHospitals.append(authHospital)
        UpdateToSettingFinishUI()
        
        if confirmInputDateIsLegal() {
            self.currentStartDate = convertStartDateToTimeString()
            self.currentEndDate = convertEndDateToTimeString()
            
            if SharingManager.sharedInstance.currentAuthType == .addAuthorization || SharingManager.sharedInstance.currentAuthType == .firstAuthorization {
                sendSetupMedicalAuth()
            } else {
                sendResetMedicalAuth()
            }
        } else {
            let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
            //alertViewController.delegate = self
            alertViewController.alertLabel.text = "結束時間不能早於開始時間"
            alertViewController.alertImageView.image = UIImage(named: "Error")
            alertViewController.alertType = .none
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickAllAction(_ sender: UIButton) {
        allAuthImageView.image = UIImage(named: "RadioBtnSelect")
        intervalAuthImageView.image = UIImage(named: "RadioBtnNoSelect")
        isSelectAll = true
        
        startDatePicker.isEnabled = false
        endDatePicker.isEnabled = false
    }
    
    @IBAction func clickIntervalAction(_ sender: UIButton) {
        allAuthImageView.image = UIImage(named: "RadioBtnNoSelect")
        intervalAuthImageView.image = UIImage(named: "RadioBtnSelect")
        isSelectAll = false
        
        startDatePicker.isEnabled = true
        endDatePicker.isEnabled = true
    }
    
    func pushToAuthorizationManagementPage() {
        // 授權管理
        if let viewControllers = navigationController?.viewControllers {
            if viewControllers.count >= 2 {
                let secondViewController = viewControllers[1]
                navigationController?.popToViewController(secondViewController, animated: true)
            }
        }
    }
    
    func pushToContinueAuthorizationPage() {
        // 繼續授權
        if let viewControllers = navigationController?.viewControllers {
            if viewControllers.count >= 3 {
                let secondViewController = viewControllers[2]
                navigationController?.popToViewController(secondViewController, animated: true)
            }
        }
    }
    
    func UpdateToSettingFinishUI() {
        step2ImageView.image = UIImage(named: "step_v")
        step2Label.font = UIFont(name: "PingFangTC-Regular", size: 13)
        step2Label.textColor = UIColor(hex: "#858585")
        step3ImageView.image = UIImage(named: "step_done")
        step3Label.font = UIFont(name: "PingFangTC-Medium", size: 14)
        step3Label.textColor = UIColor(hex: "#2E8BC7")
    }
}

extension AuthSettingStep2ViewController: AuthSuccessAlertVCDelegate {
    func clickContinueBtn() {
        pushToContinueAuthorizationPage()
    }
    
    func clickMedicalHistoryBtn() {
        if SharingManager.sharedInstance.currentAuthType == .addAuthorization {
            pushToAuthorizationManagementPage()
        } else {
            // 醫療歷程
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension AuthSettingStep2ViewController {
    func sendSetupMedicalAuth() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let setupMedicalAuthModelReqInfo: SetupMedicalAuthModel = SetupMedicalAuthModel(
            partnerId: SharingManager.sharedInstance.currentAuthPartnerId,
            departmentCodes: SharingManager.sharedInstance.currDeptCodes,
            departmentNames: SharingManager.sharedInstance.currDeptNames,
            type: isSelectAll ? "FULL" : "RANGE",
            startDate: currentStartDate,
            endDate: currentEndDate)
        SDKManager.sdk.setupMedicalAuth(postModel: setupMedicalAuthModelReqInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                if SharingManager.sharedInstance.currentAuthType == .addAuthorization {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "AuthSuccessAlertVC") as! AuthSuccessAlertVC
                        alertViewController.delegate = self
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                } else if SharingManager.sharedInstance.currentAuthType == .firstAuthorization {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "AuthSuccessAlertVC") as! AuthSuccessAlertVC
                        alertViewController.delegate = self
                        alertViewController.messageLabel.text = "是否繼續匯入其它院所醫療資料或前往醫療歷程?"
                        alertViewController.cancelButton.setTitle("醫療歷程", for: .normal)
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "AuthSuccessAlertVC") as! AuthSuccessAlertVC
                        alertViewController.delegate = self
                        alertViewController.messageLabel.text = "前往授權管理"
                        alertViewController.confirmButton.isHidden = true
                        alertViewController.cancelButton.setTitle("確定", for: .normal)
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendSetupMedicalAuth()
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
    
    func sendResetMedicalAuth() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let setupMedicalAuthModelReqInfo: SetupMedicalAuthModel = SetupMedicalAuthModel(
            partnerId: SharingManager.sharedInstance.currentAuthPartnerId,
            departmentCodes: SharingManager.sharedInstance.currDeptCodes,
            departmentNames: SharingManager.sharedInstance.currDeptNames,
            type: isSelectAll ? "FULL" : "RANGE",
            startDate: currentStartDate,
            endDate: currentEndDate)
        SDKManager.sdk.resetMedicalAuth(postModel: setupMedicalAuthModelReqInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                if SharingManager.sharedInstance.currentAuthType == .addAuthorization {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "AuthSuccessAlertVC") as! AuthSuccessAlertVC
                        alertViewController.delegate = self
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "AuthSuccessAlertVC") as! AuthSuccessAlertVC
                        alertViewController.delegate = self
                        alertViewController.messageLabel.text = "前往授權管理"
                        alertViewController.confirmButton.isHidden = true
                        alertViewController.cancelButton.setTitle("確定", for: .normal)
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendResetMedicalAuth()
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
