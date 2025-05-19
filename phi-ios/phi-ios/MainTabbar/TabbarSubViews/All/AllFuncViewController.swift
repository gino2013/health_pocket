//
//  AllFuncViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/1/30.
//

import UIKit
import ProgressHUD
import KeychainSwift

class AllFuncViewController: BaseViewController {
    
    @IBOutlet weak var memberInfoTopView: UIView!
    @IBOutlet weak var functionListBaseView: UIView!
    @IBOutlet weak var functionListView: UIStackView!
    @IBOutlet weak var supportListBaseView: UIView!
    @IBOutlet weak var supportListView: UIStackView!
    @IBOutlet weak var authManageView: AllFuncItemView!
    @IBOutlet weak var loginOlaawordView: AllFuncItemView!
    @IBOutlet weak var faceIdLoginView: AllFuncItemView!
    @IBOutlet weak var scheduleView: AllFuncItemView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var aboutPHIView: AllFuncItemView!
    @IBOutlet weak var logoutView: AllFuncItemView!
    
    var retryExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setItemView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMemberInfo()
    }
    
    func updateUI() {
        memberInfoTopView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        functionListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        supportListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
    }
    
    func setItemView() {
        authManageView.currentItemType = .authorizationManagement
        authManageView.delegate = self
        loginOlaawordView.currentItemType = .loginOlaaword
        loginOlaawordView.delegate = self
        faceIdLoginView.currentItemType = .faceIdSetting
        faceIdLoginView.delegate = self
        scheduleView.currentItemType = .schedule
        scheduleView.delegate = self
        aboutPHIView.currentItemType = .aboutPHI
        aboutPHIView.delegate = self
        logoutView.currentItemType = .logout
        logoutView.delegate = self
    }
    
    @IBAction func viewMemberProfileAction(_ sender: UIButton) {
        let vc = MemeberInfoViewController.instance()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AllFuncViewController: AllFuncItemViewDelegate {
    func pushToItemPage(itemType: AllFuncItemType) {
        switch itemType {
        case .authorizationManagement:
            let storyboard = UIStoryboard(name: "AuthManagement", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AuthManageViewController") as! AuthManageViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .loginOlaaword:
            let storyboard = UIStoryboard(name: "LoginPWord", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginPWordViewController") as! LoginPWordViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .faceIdSetting:
            let storyboard = UIStoryboard(name: "FaceIdSetting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FaceIdSettingViewController") as! FaceIdSettingViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .schedule:
            let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleSettingViewController") as! ScheduleSettingViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .aboutPHI:
            let storyboard = UIStoryboard(name: "AllFunc", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AboutController") as! AboutController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .logout:
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = "是否要登出App?"
            alertViewController.isKeyButtonLeft = false
            alertViewController.confirmButton.setTitle("取消", for: .normal)
            alertViewController.cancelButton.setTitle("確認", for: .normal)
            alertViewController.alertType = .firstAuthorization
            self.present(alertViewController, animated: true, completion: nil)
            break
        default:
            print("Unknown item type! \(itemType)")
        }
    }
}

extension AllFuncViewController {
    func getMemberInfo() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        SDKManager.sdk.requestFindMember() {
            (responseModel: PhiResponseModel<MemberRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let memberRspModel = responseModel.data else {
                    return
                }
                
                PHISDK_AllResponseData.sharedInstance.userInfo = memberRspModel
                
                DispatchQueue.main.async {
                    if memberRspModel.name.isEmpty {
                        self.welcomeLabel.text = "Hi, 使用者"
                    } else {
                        self.welcomeLabel.text = "Hi, \(memberRspModel.name)"
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getMemberInfo()
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

extension AllFuncViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        // N/A
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        // process logout
        NotificationCenter.default.post(
            name: .appLogout,
            object: self,
            userInfo: nil)
    }
}
