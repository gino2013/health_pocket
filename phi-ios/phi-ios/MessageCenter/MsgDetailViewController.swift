//
//  MsgDetailViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/27.
//

import UIKit
import ProgressHUD

class MsgDetailViewController: BaseViewController {
    
    @IBOutlet weak var firstBaseView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var openRecordButton: UIButton!
    
    var retryExecuted: Bool = false
    var messageModel: MessageCellViewModel?
    var currentTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
        
        if let messageModel = messageModel {
            updateUI(fromPreView: messageModel)
        }
        
        /*
        if let currentMedicalRecordModel = SharingManager.sharedInstance.currentMedicalRecordModel {
            getReceiveRecordsDetail(requestInfo: currentMedicalRecordModel)
        }
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = currentTitle
    }
    
    func updateUI() {
        openRecordButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        openRecordButton.layer.borderWidth = 1.0
    }
    
    func UpdateUI(fromSrvRsp: ReceiveRecordDetailRspModel) {
        //
    }
    
    func updateUI(fromPreView: MessageCellViewModel) {
        timeLabel.text = fromPreView.dateTime
        mainTitleLabel.text = fromPreView.mainTitle
        subTitleLabel.text = fromPreView.subTitle
        contentLabel.text = fromPreView.subMessage
    }
    
    @IBAction func openRemindRecoedAction(_ sender: UIButton) {
        SharingManager.sharedInstance.msgCenterPushToMedicationManagementPage = true
        _ = navigationController?.popToRootViewController({
            if let mostTopViewController = SDKUtils.mostTopViewController,
               let tabBarController = (mostTopViewController as? MainTabBarController) ?? mostTopViewController.presentingViewController as? MainTabBarController {
                tabBarController.selectedIndex = 1
            }
        })
        
        /*
        //let isSuccess = true
        let successMessage = "此功能尚未開放，敬請期待"
        //let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: "提醒", message: successMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        */
    }
}

extension MsgDetailViewController {
    func getReceiveRecordsDetail(requestInfo: MedicalRecordRspModel) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let reqInfo: GetReceiveRecordDetailModel = GetReceiveRecordDetailModel(tenantId: requestInfo.tenantId, prescriptionNo: requestInfo.prescriptionNo, medicalType: requestInfo.medicalType, diagnosisNo: requestInfo.diagnosisNo, receiveRecordId: "")
        SDKManager.sdk.getReceiveRecordsDetail(postModel: reqInfo) {
            (responseModel: PhiResponseModel<ReceiveRecordDetailRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let receiveRecordDetailInfo = responseModel.data else {
                    return
                }
                                
                DispatchQueue.main.async {
                    self.UpdateUI(fromSrvRsp: receiveRecordDetailInfo)
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getReceiveRecordsDetail(requestInfo: requestInfo)
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
