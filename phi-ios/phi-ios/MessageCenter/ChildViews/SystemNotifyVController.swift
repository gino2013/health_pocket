//
//  SystemNotifyVController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/24.
//

import UIKit
import ProgressHUD

enum MessageCellType {
    case noSubMessageType
    case containSubMessageType
}

enum PreviousPage {
    /* 醫療歷程 */
    case medicalHistory
    /* 生活習慣 */
    case livingHabit
}

class SystemNotifyVController: BaseViewController {
    
    @IBOutlet weak var hTableView: UITableView! {
        didSet {
            hTableView.dataSource = self
            hTableView.delegate = self
            hTableView.tableFooterView = UIView()
            hTableView.backgroundColor = UIColor(hex: "#FAFAFA")
            hTableView.separatorStyle = .none
            hTableView.allowsSelection = true
            hTableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    private let normalMsgCellIdentifier = "NormalMessageTableViewCell"
    private let msgCellIdentifier = "MessageTableViewCell"
    //var data = systemMessageSampleData()
    var data: [MessageCellViewModel] = []
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    var currentPage: Int = -1
    var currentQueryTime: String = ""
    var totalPage: Int = 0
    var hasNextPage: Bool = false
    var prePage: PreviousPage = .medicalHistory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        currentPage = -1
        getMessageList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateUI() {
        hTableView.register(nibWithCellClass: NormalMessageTableViewCell.self)
        hTableView.register(nibWithCellClass: MessageTableViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshMsgInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        hTableView.addSubview(refreshControl)
    }
    
    @objc func refreshMsgInfos() {
        refreshControl.endRefreshing()
        currentPage = -1
        getMessageList()
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        hTableView.isHidden = !enableHidden
    }
    
    func backToTabViewAtFirstIndex() {
        if self.prePage == .medicalHistory {
            _ = navigationController?.popViewController(animated: true)
        } else if self.prePage == .livingHabit {
            _ = navigationController?.popViewController({
                if let mostTopViewController = SDKUtils.mostTopViewController,
                   let tabBarController = (mostTopViewController as? MainTabBarController) ?? mostTopViewController.presentingViewController as? MainTabBarController {
                    tabBarController.selectedIndex = 0
                }
            })
        }
    }
}

extension SystemNotifyVController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = data[indexPath.row].cellType
        
        switch cellType {
        case .noSubMessageType:
            guard let normalMsgCell = tableView.dequeueReusableCell(withIdentifier: normalMsgCellIdentifier, for: indexPath) as? NormalMessageTableViewCell else {
                fatalError("Issue dequeuing \(normalMsgCellIdentifier)")
            }
            
            if indexPath.row < data.count {
                normalMsgCell.configureCell(viewModel: data[indexPath.row])
            }
            return normalMsgCell
            
        case .containSubMessageType:
            guard let msgItemCell = tableView.dequeueReusableCell(withIdentifier: msgCellIdentifier, for: indexPath) as? MessageTableViewCell else {
                fatalError("Issue dequeuing \(msgCellIdentifier)")
            }
            
            if indexPath.row < data.count {
                msgItemCell.configureCell(viewModel: data[indexPath.row])
            }
            return msgItemCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < data.count else {
            return
        }
        
        let item: MessageCellViewModel = data[indexPath.row]
        
        if !item.haveRead {
            item.haveRead = true
            markNotification(id: item.pushNotificationId)
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        switch item.sysNotificationType {
        /*
        case .AppointmentCancelled:
            NotificationCenter.default.post(
                name: .switchToProgressJourneyThenReload,
                object: self,
                userInfo: nil)
            NotificationCenter.default.post(
                name: .pushToQRcodePage,
                object: self,
                userInfo: nil)
            backToTabViewAtFirstIndex()
            break
            
        case .AppointmentReminderCanReceiveMedicine:
            // 可預約領藥
            NotificationCenter.default.post(
                name: .switchToProgressJourneyThenReload,
                object: self,
                userInfo: nil)
            NotificationCenter.default.post(
                name: .pushToLocationPage,
                object: self,
                userInfo: nil)
            backToTabViewAtFirstIndex()
            break
            
        case .AppointmentReminderReadyReceiveMedicine:
            NotificationCenter.default.post(
                name: .switchToProgressJourneyThenReload,
                object: self,
                userInfo: nil)
            NotificationCenter.default.post(
                name: .pushToQRcodePage,
                object: self,
                userInfo: nil)
            backToTabViewAtFirstIndex()
            break
            
        case .ChronicPrescriptionAppointmentReminder:
            NotificationCenter.default.post(
                name: .switchToProgressJourneyThenReload,
                object: self,
                userInfo: nil)
            backToTabViewAtFirstIndex()
            break
        */
            
        case .TAKE_MEDICATION_ALERT:
            let storyboard = UIStoryboard(name: "MessageCenter", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MsgDetailViewController") as! MsgDetailViewController
            vc.messageModel = item
            vc.currentTitle = "系統通知"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        
        /*
        case .PrescriptionExpirationReminder:
            NotificationCenter.default.post(
                name: .switchToFinishJourneyThenReload,
                object: self,
                userInfo: nil)
            backToTabViewAtFirstIndex()
            break
        */
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = data[indexPath.row].cellType
        
        switch cellType {
        case .noSubMessageType:
            return 78
        case .containSubMessageType:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            if self.hasNextPage {
                getMessageList()
            }
        }
    }
}

extension SystemNotifyVController {
    func stringToPushNotificationRedirectionEnum(_ input: String) -> PushNotificationRedirection? {
        return PushNotificationRedirection(rawValue: input)
    }

    func dumpSrvDataToViewModel(from: PushNotifRspModel) -> MessageCellViewModel {
        var cellMsgType: MessageCellType = .noSubMessageType
        
        if !from.content.isEmpty {
            cellMsgType = .containSubMessageType
        }
        
        return MessageCellViewModel(pushNotificationId: from.pushNotificationId, mainTitle: from.title, subTitle: from.subTitle, subMessage: from.content, dateTime: from.createTime, haveRead: from.isRead, cellType: cellMsgType, sysNotificationType: stringToPushNotificationRedirectionEnum(from.pushNotificationType) ?? .FOLLOW_UP_OUTPATIENT_APPOINTMENT_REQUESTABLE)
    }
    
    func getMessageList() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let reqInfo: GetNotifListModel = GetNotifListModel(page: self.currentPage, queryTime: self.currentQueryTime)
        SDKManager.sdk.getNotificationList(postModel: reqInfo) {
            (responseModel: PhiResponseModel<NotificationListRspModel>) in
            
            if responseModel.success {
                guard let notificationListRspModel = responseModel.data,
                      let pushNotifRspModelArray = notificationListRspModel.dataArray else {
                    return
                }
                
                if self.currentPage == -1 {
                    self.data.removeAll()
                }
                
                self.totalPage = notificationListRspModel.totalPages
                self.currentPage = notificationListRspModel.currentPage
                self.currentQueryTime = notificationListRspModel.queryTime
                if self.totalPage > self.currentPage {
                    self.hasNextPage = true
                    self.currentPage += 1
                } else {
                    self.hasNextPage = false
                }
                
                for i in 0 ..< pushNotifRspModelArray.count {
                    let item: PushNotifRspModel = pushNotifRspModelArray[i]
                    
                    self.data.append(self.dumpSrvDataToViewModel(from: item))
                }
                
                DispatchQueue.main.async {
                    if self.data.count > 0 {
                        self.hiddenNoNeedUI(enableHidden: true)
                        self.hTableView.reloadData()
                    } else {
                        self.hiddenNoNeedUI(enableHidden: false)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getMessageList()
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
            
            ProgressHUD.dismiss()
        }
    }
    
    func markNotification(id: Int) {
        let markNotificationRequest: MarkNotificationModel = MarkNotificationModel(pushNotificationId: id)
        SDKManager.sdk.requestMarkNotification(markNotificationRequest) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                //
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.markNotification(id: id)
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
