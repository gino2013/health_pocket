//
//  MedicalJourneyVController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/1/30.
//

import UIKit
import ProgressHUD

class MedicalJourneyVController: BaseViewController {
    
    // Date formatter
    // let dateFormatter = DateFormatter()
    
    @IBOutlet weak var phSegmentedControl: PHSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var inProgressMedJourneyVController: UIViewController?
    var finishMedJourneyVController: UIViewController?
    /* init. -1, left page = 0, right page =1 */
    var reloadForSwitchSegmentFlag: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // updateUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setSegmentFlagToInProgress),
                                               name: .switchToProgressJourneyThenReload,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setSegmentFlagToFinish),
                                               name: .switchToFinishJourneyThenReload,
                                               object: nil)
        
        getUnreadMessageCount()
        
        /*
         // Configure date formatter
         dateFormatter.dateStyle = .none
         dateFormatter.timeStyle = .medium
         // Schedule a timer to trigger every second to invoke method updateLabel
         Timer.scheduledTimer(timeInterval: 1,
         target: self,
         selector: #selector(updateLabel),
         userInfo: nil,
         repeats:true);
         */
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if reloadForSwitchSegmentFlag != -1 {
            if reloadForSwitchSegmentFlag == 0 {
                changeToInProgressSegment()
            } else {
                changeToFinishSegment()
            }
            
            reloadForSwitchSegmentFlag = -1
        }
    }
    
    @objc override func rightBarButtonTapped() {
        // push to Message Center
        let storyboard = UIStoryboard(name: "MessageCenter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageCenterVController") as! MessageCenterVController
        vc.hidesBottomBarWhenPushed = true
        vc.prePage = .medicalHistory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Method that updates the label text witht he current date time
    @objc func updateLabel() -> Void {
        // Update the text of the clock label with the time of the current date
        // clockLabel.text = dateFormatter.string(from: Date());
    }
    
    func updateUI() {
        let storyboard = UIStoryboard(name: "MedicalJourney", bundle: nil)
        inProgressMedJourneyVController = storyboard.instantiateViewController(withIdentifier: "InProgressMedJourneyVController")
        finishMedJourneyVController = storyboard.instantiateViewController(withIdentifier: "FinishMedJourneyVController")
        
        // 顯示初始視圖控制器（例如A）
        if let firstViewController = inProgressMedJourneyVController {
            addChild(firstViewController)
            firstViewController.view.frame = containerView.bounds
            containerView.addSubview(firstViewController.view)
            firstViewController.didMove(toParent: self)
        }
        
        phSegmentedControl.didTapSegment = { index in
            print(index)
            self.displayViewController(atIndex: index)
        }
        
        if SharingManager.sharedInstance.isRcvNewMessage {
            createRightBarButtonViaImage(imageName: "notification_new")
        } else {
            createRightBarButtonViaImage(imageName: "notification")
        }
    }
    
    func displayViewController(atIndex index: Int) {
        // 移除現有的子視圖控制器
        if let currentViewController = children.first {
            currentViewController.willMove(toParent: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
        }
        
        // 根據分段控制器的選擇，顯示對應的視圖控制器
        if index == 0, let viewController = inProgressMedJourneyVController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        } else if index == 1, let viewController = finishMedJourneyVController {
            addChild(viewController)
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
    
    @objc func setSegmentFlagToInProgress(_: Notification) {
        reloadForSwitchSegmentFlag = 0
    }
    
    func changeToInProgressSegment() {
        phSegmentedControl.currentIndex = 0
        displayViewController(atIndex: phSegmentedControl.currentIndex)
    }
    
    @objc func setSegmentFlagToFinish(_: Notification) {
        reloadForSwitchSegmentFlag = 1
    }
    
    func changeToFinishSegment() {
        phSegmentedControl.currentIndex = 1
        displayViewController(atIndex: phSegmentedControl.currentIndex)
    }
    
    func reloadInProgressMedJourneyData() {
        if let inProgressMedJourneyVC = inProgressMedJourneyVController as? InProgressMedJourneyVController {
            inProgressMedJourneyVC.reloadData()
        }
    }
}

extension MedicalJourneyVController {
    func getUnreadMessageCount() {
        /*
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        */
        SDKManager.sdk.getCountUnreadNotification() {
            (responseModel: PhiResponseModel<CountUnreadNotifRspModel>) in
            
            // ProgressHUD.dismiss()
            
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
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
