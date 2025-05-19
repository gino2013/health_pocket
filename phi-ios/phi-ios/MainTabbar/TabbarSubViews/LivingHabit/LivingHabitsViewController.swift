//
//  LivingHabitsViewController.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/7.
//

import UIKit
import ProgressHUD

class LivingHabitsViewController: BaseViewController {
    
    @IBOutlet weak var firstTitleView: UIView!
    @IBOutlet weak var alertNextView: UIView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var newNoteView: UIView!
    @IBOutlet weak var noReminderView: UIView!
    
    @IBOutlet weak var secondTitleView: UIView!
    @IBOutlet weak var alertNextSportView: UIView!
    @IBOutlet weak var lastWeekNoteView: UIView!
    
    var pushPageFlag: Bool = false
    var retryExecuted: Bool = false
    var isNoReminderMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "生活習慣"
        //replaceBackBarButtonItem()
        //updateUI()
        getUnreadMessageCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if SharingManager.sharedInstance.reminderPushToMedicationManagementPage {
            SharingManager.sharedInstance.reminderPushToMedicationManagementPage = false
            pushToMedicationManagementPage(animate: false)
        } else if SharingManager.sharedInstance.msgCenterPushToMedicationManagementPage {
            SharingManager.sharedInstance.msgCenterPushToMedicationManagementPage = false
            pushToMedicationManagementPage()
        }
        
        /*
        let testModel = ReminderNotificationModel(json: JSON([
            "remindDateTime": "2024/08/02 07:30:00",
            "pushNotificationType": "TAKE_MEDICATION_ALERT",
            "content": "飯後1顆降血壓藥",
            "parameters": [
                "reminderDate": "2024/08/02",
                "reminderTime": "07:30",
                "reminderSettingId": "5",
                "reminderTimeSettingId": "11"
            ]
        ]))
        LocalNotificationUtils.scheduleTestNotification(model: testModel)
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
        
    func updateUI() {
        // 創建一個新的視圖，這裡作為範例
        /*
        let bottomView = UIView()
        bottomView.backgroundColor = .red
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomView)

        // 設置 Auto Layout 約束，讓視圖對齊 Safe Area 底部
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),  // 對齊 Safe Area 底部
            bottomView.heightAnchor.constraint(equalToConstant: 50)  // 設定一個高度
        ])
        */
    
        if SharingManager.sharedInstance.isRcvNewMessage {
            createRightBarButtonViaImage(imageName: "notification_new")
        } else {
            createRightBarButtonViaImage(imageName: "notification")
        }
        
        noteView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        noteView.layer.borderWidth = 1.0
        newNoteView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        newNoteView.layer.borderWidth = 1.0
        
        alertNextView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        alertNextSportView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        lastWeekNoteView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        noReminderView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        if isNoReminderMode {
            alertNextView.isHidden = true
            newNoteView.isHidden = true
            secondTitleView.isHidden = true
            alertNextSportView.isHidden = true
            lastWeekNoteView.isHidden = true
            noReminderView.isHidden = false
        }
    }
    
    @objc override func rightBarButtonTapped() {
        // push to Message Center
        let storyboard = UIStoryboard(name: "MessageCenter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageCenterVController") as! MessageCenterVController
        vc.hidesBottomBarWhenPushed = true
        vc.prePage = .livingHabit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToMedicationManagementPage(animate: Bool = true) {
        //let storyboard = UIStoryboard(name: "MedManage", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "MedicationManagementVC") as! MedicationManagementVC
        let storyboard = UIStoryboard(name: "NewMedManage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewMedManagementVC") as! NewMedManagementVC
        if !animate {
            vc.showPanModal = true
        }
        self.navigationController?.pushViewController(vc, animated: animate)
    }
    
    @IBAction func pushToManageMedAction(_ sender: UIButton) {
        pushToMedicationManagementPage()
    }
    
    @objc func changePushPageFlag(_: Notification) {
        pushPageFlag = true
    }
}

extension LivingHabitsViewController {
    static func instance() -> LivingHabitsViewController {
        let viewController = LivingHabitsViewController(nibName: String(describing: self), bundle: nil)
        return viewController
    }
}

extension LivingHabitsViewController {
    func getUnreadMessageCount() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.getCountUnreadNotification() {
            (responseModel: PhiResponseModel<CountUnreadNotifRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let rspInfo = responseModel.data else {
                    return
                }
                
                SharingManager.sharedInstance.unreadMessageCount = rspInfo.count
                
                if SharingManager.sharedInstance.unreadMessageCount > 0 {
                    SharingManager.sharedInstance.isRcvNewMessage = true
                } else {
                    SharingManager.sharedInstance.isRcvNewMessage = false
                }
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getUnreadMessageCount()
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
