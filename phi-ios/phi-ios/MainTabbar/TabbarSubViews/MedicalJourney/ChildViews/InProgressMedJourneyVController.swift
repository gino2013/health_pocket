//
//  InProgressMedJourneyVController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/4/24.
//

import UIKit
import ProgressHUD
import KeychainSwift

class InProgressMedJourneyVController: BaseViewController {
    
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            historyTableView.dataSource = self
            historyTableView.delegate = self
            historyTableView.tableFooterView = UIView()
            historyTableView.backgroundColor = UIColor(hex: "#FAFAFA")
            historyTableView.separatorStyle = .none
            //historyTableView.allowsSelection = false
            historyTableView.rowHeight = UITableView.automaticDimension
            historyTableView.estimatedRowHeight = 2
            historyTableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    //@IBOutlet weak var allButton: UIButton!
    //@IBOutlet weak var OutpatientClinicButton: UIButton!
    //@IBOutlet weak var postponeButton: UIButton!
    
    @IBOutlet weak var addAuthButton: UIButton!
    // new feature
    @IBOutlet weak var alertInfoView: UIView!
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    @IBOutlet weak var buttonCollectionView: UICollectionView!
    
    //var collectionView: UICollectionView!
    let buttonTitles = ["全部", "門診", "連續處方箋", "運動處方箋", "運動課程"]
    var currentDataSource: [MedHistoryTViewCellViewModel] = []
    
    /*
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "ButtonCell")
        return collectionView
    }()
    */
    
    private let cellIdentifier = "MedicalHistoryTViewCell"
    //var medicalHistorys: [String] = []
    // Test Data
    var data: [MedHistoryTViewCellViewModel] = sampleData()
    // Server Data
    var medicalRecordInfoList: [MedicalRecordRspModel]?
    //var data = [MedHistoryTViewCellViewModel]()
    var retryExecuted: Bool = false
    var currentCountExpiredMedicalAuth: Int = 0
    var postponeReloadFlag: Bool = true
    var pushPageFlag: Int = 0   /* 0, 1:Location 2:QRCode*/
    var reSendApiFlag: Bool = true
    private var isFirstTime: Bool = true
    var selectedButtonIndex: Int = 0
    private var isInitialLayoutDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        settingObserver()
        // scheduleLocalNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Game Request"
        content.subtitle = "Five Card Draw"
        content.body = "Bob wants to play poker"
        content.categoryIdentifier = "GAME_INVITATION"
        content.sound = .default
        content.userInfo = ["gcm.message_id" : "122121212",
                            "phi_local_notification" : "AppointmentCancelled"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 61, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SharingManager.sharedInstance.isInProgressMedJourneyVController = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if reSendApiFlag {
            reloadData()
        } else {
            reSendApiFlag = true
        }
    }
    
    @objc func pushToResultPage() {
        let storyboard = UIStoryboard(name: "MedResult", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MedResultViewController") as! MedResultViewController
        vc.isReceiveMedicineFinish = false
        vc.receiveRecordId = SharingManager.sharedInstance.apns_receiveRecordId.integer
        vc.needBackToRoot = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func reloadData() {
        SharingManager.sharedInstance.isInProgressMedJourneyVController = true
        
        callAllAPIsConcurrently() {
            DispatchQueue.main.async {
                if self.currentDataSource.count > 0 {
                    self.alertInfoView.isHidden = true
                    self.hiddenNoNeedUI(enableHidden: true)
                    self.historyTableView.reloadData()
                } else {
                    self.alertInfoView.isHidden = true
                    self.hiddenNoNeedUI(enableHidden: false)
                }
                
                // Push Mode
                if self.pushPageFlag != 0 {
                    if self.pushPageFlag == 1 {
                        SharingManager.sharedInstance.isPushNotificationMode = false
                        
                        let storyboard = UIStoryboard(name: "MedLocation", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MedLocationViewController") as! MedLocationViewController
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if self.pushPageFlag == 2 {
                        SharingManager.sharedInstance.isPushNotificationMode = false
                        
                        let storyboard = UIStoryboard(name: "Prescription", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MedicineQRViewController") as! MedicineQRViewController
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if self.pushPageFlag == 3 {
                        SharingManager.sharedInstance.isPushNotificationMode = false
                        
                        self.pushToResultPage()
                    } else if self.pushPageFlag == 4 {
                        let storyboard = UIStoryboard(name: "Appointment", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AppointStep1ViewController") as! AppointStep1ViewController
                        vc.hidesBottomBarWhenPushed = true
                        // ???
                        // vc.needBackToRoot = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    self.pushPageFlag = 0
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.isFirstLogin() != nil {
            if UserDefaults.standard.isFirstLogin()! == true {
                if UserDefaults.standard.isEnableFaceId() == false {
                    // face id flow
                    let alertViewController = UINib.load(nibName: "FaceIdSettingAlertVC") as! FaceIdSettingAlertVC
                    alertViewController.delegate = self
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
                UserDefaults.standard.setIsFirstLogin(value: false)
            } else {
                // WFI - wait server
                // checkImportAuthData()
            }
        }
    }
    
    func settingObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData),
            name: .InProgressMedVC_Reload,
            object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changePushPageFlagToLocationPage),
                                               name: .pushToLocationPage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changePushPageFlagToQRcodePage),
                                               name: .pushToQRcodePage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changePushPageFlagToAppointStepPage),
                                               name: .pushToAppointStepPage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changePushPageFlagToResultPage),
                                               name: .pushToResultPage,
                                               object: nil)
    }
    
    // fix: Apple UI issue, at iphone 14 pro, iOS 17.0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isInitialLayoutDone {
            buttonCollectionView.contentOffset = CGPoint(x: -22, y: 0)
            isInitialLayoutDone = true
        }
    }

    func updateUI() {
        historyTableView.register(nibWithCellClass: MedicalHistoryTViewCell.self)
        
        emptyImageView.isHidden = true
        noteLabel.isHidden = true
        addAuthButton.isHidden = true
        
        buttonCollectionView.delegate = self
        buttonCollectionView.dataSource = self
        buttonCollectionView.showsHorizontalScrollIndicator = false
        
        let nib = UINib(nibName: "ButtonCollectionViewCell", bundle: nil)
        buttonCollectionView.register(nib, forCellWithReuseIdentifier: "ButtonCollectionViewCell")
        
        // 設置 Flow Layout 到滾動方向為水平
        if let layout = buttonCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            // 設定左右兩邊的間距為22
            layout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        }
        
        // 預選中第一個按鈕
        buttonCollectionView.selectItem(at: IndexPath(item: selectedButtonIndex, section: 0), animated: false, scrollPosition: .left)
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        if self.data.count > 0 {
            buttonCollectionView.isHidden = false
        } else {
            buttonCollectionView.isHidden = !enableHidden
        }
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        historyTableView.isHidden = !enableHidden
        
        addAuthButton.isHidden = SharingManager.sharedInstance.effectiveMedicalAuth
        
        if SharingManager.sharedInstance.effectiveMedicalAuth {
            noteLabel.text = "此為授權完成但該醫院內沒有醫療資料的情況"
            
            if selectedButtonIndex != 0 || selectedButtonIndex != 1 {
                if selectedButtonIndex < buttonTitles.count {
                    noteLabel.text = "沒有\(buttonTitles[selectedButtonIndex])資料"
                }
            }
            
        } else {
            noteLabel.text = "您目前沒有醫療歷程！\n請新增資料授權以開始醫療歷程"
        }
        
        checkImportAuthData()
    }
    
    func showPostponeAlertView() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "提醒您，目前有\(self.currentCountExpiredMedicalAuth)家醫療院所的醫療資料授權已經到期，請盡快展延授權。"
        alertViewController.isKeyButtonLeft = true
        alertViewController.confirmButton.setTitle("前往授權", for: .normal)
        alertViewController.cancelButton.isHidden = true
        alertViewController.alertType = .postponeAuthorization
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func postponeAction(_ sender: UIButton) {
        showPostponeAlertView()
    }
    
    @IBAction func addAuthAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Hospital", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HospitalListViewController") as! HospitalListViewController
        SharingManager.sharedInstance.currentAuthType = .firstAuthorization
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changePushPageFlagToLocationPage(_: Notification) {
        pushPageFlag = 1
        // WFI
    }
    
    @objc func changePushPageFlagToQRcodePage(_: Notification) {
        pushPageFlag = 2
        // WFI
    }
    
    @objc func changePushPageFlagToResultPage(_: Notification) {
        pushPageFlag = 3
        // WFI
    }
    
    @objc func changePushPageFlagToAppointStepPage(_: Notification) {
        pushPageFlag = 4
        // WFI
    }
    
}

extension InProgressMedJourneyVController: UITableViewDelegate, UITableViewDataSource {
    func closeOtherExpandedCell(index: Int) {
        for i in 0 ..< currentDataSource.count {
            if i != index {
                if currentDataSource[i].expanded == true {
                    currentDataSource[i].expanded = false
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MedicalHistoryTViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        cell.selectionStyle = .none
        let model = data[indexPath.row]
        cell.configureCell(viewModel: model)
        cell.stackView.arrangedSubviews[1].isHidden = !model.expanded
        cell.cellIndex = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        
        let isExpanded = data[indexPath.row].expanded
        data[indexPath.row].expanded = !isExpanded
        
        //closeOtherExpandedCell(index: indexPath.row)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        //tableView.reloadData()
        tableView.endUpdates()
    }
    
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 70
     }
     */
}

extension InProgressMedJourneyVController: FaceIdSettingAlertVCDelegate, FaceIdPrivacyPolicyVCDelegate {
    func showSettingFaceIdAlert() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "您的裝置尚未設定Face ID，請先進行設定裝置開啟授權"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("下次再說", for: .normal)
        alertViewController.cancelButton.setTitle("前往設定", for: .normal)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showSettingSuccessAlert() {
        UserDefaults.standard.setEnableFaceId(value: true)
        
        let alertViewController = UINib.load(nibName: "ModifyResultAlertVC") as! ModifyResultAlertVC
        alertViewController.alertLabel.text = "設定成功"
        alertViewController.delegate = self
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func clickSettingNowBtn() {
        let storyboard = UIStoryboard(name: "FaceIdPrivacyPolicy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FaceIdPrivacyPolicyViewController") as! FaceIdPrivacyPolicyViewController
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkImportAuthData() {
        if !SharingManager.sharedInstance.effectiveMedicalAuth {
            let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
            alertViewController.delegate = self
            alertViewController.messageLabel.text = "是否加入國泰醫院的醫療資料，開始使用完整功能？"
            alertViewController.isKeyButtonLeft = false
            alertViewController.confirmButton.setTitle("稍後加入", for: .normal)
            alertViewController.cancelButton.setTitle("確定", for: .normal)
            alertViewController.alertType = .firstAuthorization
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            if self.currentCountExpiredMedicalAuth > 0 {
                showPostponeAlertView()
            }
        }
    }
    
    func clickNotSettingBtn() {
        checkImportAuthData()
    }
}

extension InProgressMedJourneyVController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        if alertType == .postponeAuthorization {
            let storyboard = UIStoryboard(name: "AuthPostpone", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AuthPostponeViewController") as! AuthPostponeViewController
            vc.hidesBottomBarWhenPushed = true
            vc.onNoNeedAskPostpone = { (reloadFlag: Bool) -> () in
                self.postponeReloadFlag = !reloadFlag
                self.currentCountExpiredMedicalAuth = 0
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .faceId {
            openBiometricSettings()
        } else if alertType == .firstAuthorization {
            let storyboard = UIStoryboard(name: "Hospital", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HospitalListViewController") as! HospitalListViewController
            SharingManager.sharedInstance.currentAuthType = .firstAuthorization
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func openBiometricSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}

extension InProgressMedJourneyVController {
    func dumpSrvDataToViewModel(from: MedicalRecordRspModel, isFirstItem: Bool) -> MedHistoryTViewCellViewModel {
        let nthReceiveTimeStr: String = "第\(from.nthReceiveTime)次領藥"
        let dataRangeStr: String = "\(from.opdDate)-\(from.endDate)"
        
        if isFirstItem {
            return MedHistoryTViewCellViewModel(hospitalName: from.hospitalName, type: medicalTypeMapping[from.medicalType] ?? "", nthReceiveTime: nthReceiveTimeStr, date: from.opdDate, name: from.physicianName, diseaseType: from.icdName, dateRange: dataRangeStr, rcvStatus: from.receiveStatus, rcvStatusDesc: from.receiveStatusDesc, tenantId: from.tenantId, prescriptionId: from.prescriptionNo, isPrescriptionEnded: from.isPrescriptionEnded, expanded: true)
        }
        
        return MedHistoryTViewCellViewModel(hospitalName: from.hospitalName, type: medicalTypeMapping[from.medicalType] ?? "", nthReceiveTime: nthReceiveTimeStr, date: from.opdDate, name: from.physicianName, diseaseType: from.icdName, dateRange: dataRangeStr, rcvStatus: from.receiveStatus, rcvStatusDesc: from.receiveStatusDesc, tenantId: from.tenantId, prescriptionId: from.prescriptionNo, isPrescriptionEnded: from.isPrescriptionEnded, expanded: false)
    }
    
    func getMedRecordWithPrescription(medicalType: String,
                                      completion: @escaping () -> Void) {
        //ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        //ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        //ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let getMedRecordWithPrescriptionReqInfo: GetMedRecWithPrescriptionModel = GetMedRecWithPrescriptionModel(medicalType: medicalType, ongoingPrescription: true)
        SDKManager.sdk.getMedRecordWithPrescription(postModel: getMedRecordWithPrescriptionReqInfo) {
            (responseModel: PhiResponseModel<MedicalRecordListRspModel>) in
            
            //ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let medicalRecordListRspModel = responseModel.data,
                      let medicalRecordDataArray = medicalRecordListRspModel.dataArray else {
                    completion()
                    return
                }
                
                self.medicalRecordInfoList = medicalRecordDataArray
                
                self.data.removeAll()
                
                for i in 0 ..< medicalRecordDataArray.count {
                    let recordItem: MedicalRecordRspModel = medicalRecordDataArray[i]
                    
                    if i == 0 {
                        self.data.append(self.dumpSrvDataToViewModel(from: recordItem, isFirstItem: true))
                    } else {
                        self.data.append(self.dumpSrvDataToViewModel(from: recordItem, isFirstItem: false))
                    }
                }
                
                self.currentDataSource = self.data
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getMedRecordWithPrescription(medicalType: medicalType, completion: completion)
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib(nibName: "VerifyResultAlertVC", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        alertViewController.alertType = .none
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                    completion()
                })
                return
            }
            
            completion()
        }
    }
    
    func getCountExpiredMedAuth(completion: @escaping () -> Void) {
        let keychain = KeychainSwift()
        let idTokenForAPI: String = keychain.get("idToken") ?? ""
        
        SDKManager.sdk.getCountExpiredMedAuth(idTokenForAPI) {
            (responseModel: PhiResponseModel<CountExpiredMedicalRspModel>) in
            
            if responseModel.success {
                guard let countExpireMedRspInfo = responseModel.data else {
                    completion()
                    return
                }

                print("\(countExpireMedRspInfo.countExpiredMedicalAuth)!")
                self.currentCountExpiredMedicalAuth = countExpireMedRspInfo.countExpiredMedicalAuth
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getCountExpiredMedAuth{}
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        self.alertInfoView.isHidden = false
                        
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        alertViewController.alertType = .none
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
            
            completion()
        }
    }
    
    func checkEffectiveMedicalAuth(completion: @escaping () -> Void) {
        let keychain = KeychainSwift()
        let idTokenForAPI: String = keychain.get("idToken") ?? ""
        
        SDKManager.sdk.checkEffectiveMedicalAuth(idTokenForAPI) {
            (responseModel: PhiResponseModel<CheckEffMedAuthRspModel>) in
            
            // ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let checkEffMedAuthRspInfo = responseModel.data else {
                    completion()
                    return
                }
                
                print("\(checkEffMedAuthRspInfo.effectiveMedicalAuth)!")
                SharingManager.sharedInstance.effectiveMedicalAuth = checkEffMedAuthRspInfo.effectiveMedicalAuth
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getCountExpiredMedAuth{}
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        self.alertInfoView.isHidden = false
                        
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.alertLabel.text = responseModel.message ?? ""
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        alertViewController.alertType = .none
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
            }
            completion()
        }
    }
    
    func saveMobileAPNSToken(completion: @escaping () -> Void) {
        //ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        //ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        //ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let requestInfo: SaveAPNSTokenModel = SaveAPNSTokenModel(pushNotificationToken: SharingManager.sharedInstance.fcmToken)
        SDKManager.sdk.requestSaveAPNSToken(requestInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            // ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    completion()
                    return
                }
            
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
            }
            
            completion()
        }
    }
}

extension InProgressMedJourneyVController {
    func callAllAPIsConcurrently(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        dispatchGroup.enter()
        dispatchQueue.async {
            self.getMedRecordWithPrescription(medicalType: "1") {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        dispatchQueue.async {
            self.checkEffectiveMedicalAuth {
                dispatchGroup.leave()
            }
        }
        
        if self.postponeReloadFlag {
            dispatchGroup.enter()
            dispatchQueue.async {
                self.getCountExpiredMedAuth {
                    dispatchGroup.leave()
                }
            }
        }
        
        if isFirstTime {
            dispatchGroup.enter()
            dispatchQueue.async {
                LocalNotificationUtils.syncAndGetReminderNotifications {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.enter()
            dispatchQueue.async {
                self.saveMobileAPNSToken {
                    dispatchGroup.leave()
                }
            }
            
            isFirstTime = false
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All API calls are complete.")
            self.postponeReloadFlag = true
            ProgressHUD.dismiss()
            completion()
        }
    }
}

extension InProgressMedJourneyVController: MedicalHistoryTViewCellDelegate {
    func didTapLeftButtonAtCellIndex(_ cell: MedicalHistoryTViewCell, index: Int) {
        print("didTapLeftButtonAtCellIndex!")
        
        if let medicalRecordInfoList = self.medicalRecordInfoList {
            let selectItem: MedicalRecordRspModel = medicalRecordInfoList[index]
            let storyboard = UIStoryboard(name: "MedLocation", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedLocationViewController") as! MedLocationViewController
            vc.hidesBottomBarWhenPushed = true
            if SharingManager.sharedInstance.isPushNotificationMode == false {
                SharingManager.sharedInstance.apns_tenantId = selectItem.tenantId
                SharingManager.sharedInstance.apns_medicalType = selectItem.medicalType
                SharingManager.sharedInstance.apns_diagnosisNo = selectItem.diagnosisNo
                SharingManager.sharedInstance.apns_prescriptionNo = selectItem.prescriptionNo
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        /*
         let isSuccess = true
         let successMessage = "此功能尚未開放，敬請期待"
         let errorMessage = "Something went wrong. Please try again"
         let alert = UIAlertController(title: isSuccess ? "提醒": "錯誤", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         */
    }
    
    func didTapRightButtonAtCellIndex(_ cell: MedicalHistoryTViewCell, index: Int) {
        if let medicalRecordInfoList = self.medicalRecordInfoList {
            let selectItem: MedicalRecordRspModel = medicalRecordInfoList[index]
            
            // 領藥狀態: 0-現場已領藥、1-已預約、2-可領藥 4.預約已領藥
            if selectItem.receiveStatus == "1" || selectItem.receiveStatus == "4" {
                let storyboard = UIStoryboard(name: "Appointment", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AppointStep1ViewController") as! AppointStep1ViewController
                vc.hidesBottomBarWhenPushed = true
                if SharingManager.sharedInstance.isPushNotificationMode == false {
                    SharingManager.sharedInstance.apns_tenantId = selectItem.tenantId
                    SharingManager.sharedInstance.apns_medicalType = selectItem.medicalType
                    SharingManager.sharedInstance.apns_diagnosisNo = selectItem.diagnosisNo
                    SharingManager.sharedInstance.apns_prescriptionNo = selectItem.prescriptionNo
                }
                vc.needBackToRoot = false
                vc.onNoNeedReSendAPI = { (reSendFlag: Bool) -> () in
                    self.reSendApiFlag = reSendFlag
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let storyboard = UIStoryboard(name: "Prescription", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MedicineQRViewController") as! MedicineQRViewController
                vc.hidesBottomBarWhenPushed = true
                if SharingManager.sharedInstance.isPushNotificationMode == false {
                    SharingManager.sharedInstance.apns_tenantId = selectItem.tenantId
                    SharingManager.sharedInstance.apns_medicalType = selectItem.medicalType
                    SharingManager.sharedInstance.apns_diagnosisNo = selectItem.diagnosisNo
                    SharingManager.sharedInstance.apns_prescriptionNo = selectItem.prescriptionNo
                }
                vc.onNoNeedReSendAPI = { (reSendFlag: Bool) -> () in
                    self.reSendApiFlag = reSendFlag
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension InProgressMedJourneyVController: ModifyResultAlertVCDelegate {
    func clickBtn() {
        checkImportAuthData()
    }
}

extension InProgressMedJourneyVController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
        
        let isSelected = indexPath.item == selectedButtonIndex
        cell.configureCell(btnTitle: buttonTitles[indexPath.item], 
                           isSelected: isSelected)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedButtonIndex {
            return
        }
        
        // 紀錄上一個選中的索引
        let previousSelectedIndex = selectedButtonIndex
        
        // 更新選中的索引
        selectedButtonIndex = indexPath.item
        
        // 刷新所有 cell 的 UI 狀態
        // buttonCollectionView.reloadData()
        // 刷新當前和先前選中的 cell
        let indicesToReload = [IndexPath(item: previousSelectedIndex, section: 0), IndexPath(item: selectedButtonIndex, section: 0)]
        collectionView.reloadItems(at: indicesToReload)
        
        // 更新資料來源
        switch indexPath.item {
        case 0:
            currentDataSource = self.data
        case 1:
            currentDataSource = self.data
        case 2:
            currentDataSource = []
        case 3:
            currentDataSource = []
        case 4:
            currentDataSource = []
        default:
            break
        }
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        if self.currentDataSource.count > 0 {
            self.alertInfoView.isHidden = true
            self.hiddenNoNeedUI(enableHidden: true)
            // 刷新 TableView 的資料
            self.historyTableView.reloadData()
        } else {
            self.alertInfoView.isHidden = true
            self.hiddenNoNeedUI(enableHidden: false)
        }
        
        // 0.8 秒後自動隱藏 ProgressHUD
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ProgressHUD.dismiss()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 32)
    }
    
    // 設置每個 item 之間的水平間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // 設置每一行之間的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // 每一行之間的間距16，通常用於垂直方向
    }
}
