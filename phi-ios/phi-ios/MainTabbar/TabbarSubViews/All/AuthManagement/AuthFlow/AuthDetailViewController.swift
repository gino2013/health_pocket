//
//  AuthDetailViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/4/18.
//

import UIKit
import ProgressHUD

class AuthDetailViewController: BaseViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var siyjYuqrLabel: UILabel!
    @IBOutlet weak var siyjDtRangLabel: UILabel!
    @IBOutlet weak var departmentNamesLabel: UILabel!
    
    var hospitalName: String = ""
    var currentPartnerId: Int = 0
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = hospitalName
        replaceBackBarButtonItem()
        updateUI()
        
        sendFindMedicalAuth(partnerId: currentPartnerId)
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
    
    func createRightBarButton() {
        let titleLabel = UILabel()
        titleLabel.text = "停止授權"
        titleLabel.textColor = UIColor(hex: "#34393D")
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customBarButtonTapped))
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.isUserInteractionEnabled = true
        
        let customBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = customBarButton
    }
    
    func updateUI() {
        createRightBarButton()
        
        baseView.layer.cornerRadius = 8
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1.0)?.cgColor
    }
    
    func UpdateUI(fromSrvRsp: MedicalAuthRspModel) {
        organizationNameLabel.text = fromSrvRsp.organizationName
        siyjYuqrLabel.text = "使用者授權"
        if fromSrvRsp.authorizationType == "FULL" {
            siyjDtRangLabel.text = "全部授權"
        } else {
            siyjDtRangLabel.text = "\(fromSrvRsp.startDate)~\(fromSrvRsp.endDate)"
        }
        departmentNamesLabel.text = fromSrvRsp.departmentNames
    }
    
    @IBAction func changeAuthAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AuthPrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthPrivacyPolicyViewController") as! AuthPrivacyPolicyViewController
        vc.hospitalName = hospitalName
        SharingManager.sharedInstance.currentAuthType = .changeAuthorization
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func customBarButtonTapped() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "停止授權後，你將無法在此APP上查看相關資料。惟後續可以重新授權。確定停止授權？"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確定", for: .normal)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension AuthDetailViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        // cancel
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        // confirm
        deleteMedicalAuth(partnerId: currentPartnerId)
    }
}

extension AuthDetailViewController: StopAuthAlertVCDelegate {
    func clickConfirmBtn() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AuthDetailViewController {
    func sendFindMedicalAuth(partnerId: Int) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let findMedicalDeptModelReqInfo: FindMedicalDeptModel = FindMedicalDeptModel(partnerId: partnerId)
        SDKManager.sdk.findMedicalAuth(postModel: findMedicalDeptModelReqInfo) {
            (responseModel: PhiResponseModel<MedicalAuthRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let medicalAuthRspModel = responseModel.data else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.UpdateUI(fromSrvRsp: medicalAuthRspModel)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.sendFindMedicalAuth(partnerId: self.currentPartnerId)
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
    
    func deleteMedicalAuth(partnerId: Int) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let deleteMedicalAuthReqInfo: DeleteMedicalAuthModel = DeleteMedicalAuthModel(partnerId: partnerId)
        SDKManager.sdk.deleteMedicalAuth(postModel: deleteMedicalAuthReqInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "StopAuthAlertVC") as! StopAuthAlertVC
                    alertViewController.delegate = self
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.deleteMedicalAuth(partnerId: SharingManager.sharedInstance.currentAuthPartnerId)
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
