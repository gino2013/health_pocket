//
//  AuthPostponeViewController.swift
//  Startup
//
//  Created by Kenneth Wu on 2024/4/25.
//

import UIKit
import ProgressHUD
import KeychainSwift

enum PostponeMode: Int {
    case extend
    case terminate
}

class HospitalInfo {
    var medicalAuthId: Int
    var partnerId: Int
    var tenantId: String
    var partnerOrgName: String
    var isSelected: Bool
    
    init(medicalAuthId: Int, partnerId: Int, tenantId: String, partnerOrgName: String, isSelected: Bool) {
        self.medicalAuthId = medicalAuthId
        self.partnerId = partnerId
        self.tenantId = tenantId
        self.partnerOrgName = partnerOrgName
        self.isSelected = isSelected
    }
}

class AuthPostponeViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var allSelectButton: UIButton!
    
    private var hospitals: [HospitalInfo] = [
        HospitalInfo(medicalAuthId: 0, partnerId: 0, tenantId: "xxxx11", partnerOrgName: "樹大2醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 1, partnerId: 1, tenantId: "xxxx22", partnerOrgName: "參天上醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 2, partnerId: 2, tenantId: "xxxx33", partnerOrgName: "參天上1醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 3, partnerId: 3, tenantId: "xxxx44", partnerOrgName: "參天上2醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 4, partnerId: 4, tenantId: "xxxx55", partnerOrgName: "參天上3醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 5, partnerId: 5, tenantId: "xxxx66", partnerOrgName: "參天上4醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 6, partnerId: 6, tenantId: "xxxx77", partnerOrgName: "參天上5醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 7, partnerId: 7, tenantId: "xxxx88", partnerOrgName: "參天上6醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 8, partnerId: 8, tenantId: "xxxx99", partnerOrgName: "參天上7醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 9, partnerId: 9, tenantId: "xxxx10", partnerOrgName: "參天上8醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 10, partnerId: 10, tenantId: "xxxx111", partnerOrgName: "參天上9醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 11, partnerId: 11, tenantId: "xxxx222", partnerOrgName: "參天上11醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 12, partnerId: 12, tenantId: "xxxx333", partnerOrgName: "參天上12醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 13, partnerId: 13, tenantId: "xxxx444", partnerOrgName: "參天上111醫院", isSelected: true),
        HospitalInfo(medicalAuthId: 14, partnerId: 14, tenantId: "xxxx555", partnerOrgName: "參天上144醫院", isSelected: true)
    ]
    var isAllSelectEnable: Bool = true {
        didSet {
            if isAllSelectEnable {
                allSelectButton.setImage(UIImage(named: "checkbox_active_20x20"), for: .normal)
            } else {
                allSelectButton.setImage(UIImage(named: "checkbox_default_20x20"), for: .normal)
            }
        }
    }
    var retryExecuted: Bool = false
    var currentAuthIds: [Int] = []
    var currentTerminateIds: [Int] = []
    var currentPostponeMode: PostponeMode = .extend
    var onNoNeedAskPostpone: ((_ reloadFlag: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "授權醫療資料"
        replaceBackBarButtonItem()
        createRightBarButton()
        updateUI()
        getExpiredMedAuthList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        //scrollView.contentOffset = .zero
        scrollView.layoutIfNeeded()
    }
    
    func createRightBarButton() {
        let titleLabel = UILabel()
        titleLabel.text = "全部停止授權"
        titleLabel.textColor = UIColor(hex: "#34393D")
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customBarButtonTapped))
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.isUserInteractionEnabled = true
        
        let customBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = customBarButton
    }
    
    func updateUI() {
        itemListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
          
        configureButtons(enable: true)
        
        // 移除所有 subView
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    func getSelectItemNumber() -> Int {
        var itemNum: Int = 0
        
        for i in 0 ..< hospitals.count {
            if hospitals[i].isSelected {
                itemNum += 1
            }
        }
        
        return itemNum
    }
    
    func checkIfEnableButton() {
        configureButtons(enable: false)
        
        for i in 0 ..< hospitals.count {
            if hospitals[i].isSelected {
                configureButtons(enable: true)
                break
            }
        }
    }
    
    func configureButtons(enable: Bool) {
        if enable {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor(hex: "#3399DB", alpha: 1)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            sendButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            sendButton.layer.borderWidth = 1.0
        } else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1.0)
            sendButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1.0), for: .disabled)
            //sendButton.setTitleColor(UIColor.white, for: .normal)
            sendButton.layer.borderColor = UIColor(hex: "#EFF0F1", alpha: 1)!.cgColor
            sendButton.layer.borderWidth = 1.0
        }
    }
    
    func processAllSelect(isAllSelectEnable: Bool) {
        if isAllSelectEnable {
            hospitals.forEach { $0.isSelected = true }
        } else {
            hospitals.forEach { $0.isSelected = false }
        }
        
        configureButtons(enable: isAllSelectEnable)
        
        for subview in itemListView.arrangedSubviews {
            let tmpView: MedicalItemSelectView = subview as! MedicalItemSelectView
            
            tmpView.isSelect = isAllSelectEnable
        }
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        if isAllSelectEnable {
            showConfirmPostponeAlert()
        } else {
            currentPostponeMode = .extend
            checkPrescriptionStatus()
        }
    }
    
    @IBAction func ClickAllSelectAction(_ sender: UIButton) {
        isAllSelectEnable = !isAllSelectEnable
        processAllSelect(isAllSelectEnable: isAllSelectEnable)
    }
    
    func showFirstAlert() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "您還有預約/現場領藥未領取，是否繼續停止授權？"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        if currentPostponeMode == .extend {
            alertViewController.alertType = .postpone_confirmAuthorization_1
        } else {
            alertViewController.alertType = .postpone_cancelAuthorization_1
        }
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showSecondAlert() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "停止授權後，您將無法在此APP上查看相關資料。惟後續可以重新授權。確定停止授權？"
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .postpone_cancelAuthorization_2
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showConfirmPostponeAlert() {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        
        if getSelectItemNumber() == hospitals.count {
            // all select
            alertViewController.messageLabel.text = "是否確認延展醫療資料授權?"
        } else {
            let unSelectNum: Int = hospitals.count - getSelectItemNumber()
            
            alertViewController.messageLabel.text = "有\(unSelectNum)家醫療院所尚未勾選，未勾選的資療院所資料，你將無法在此APP上查看相關資料。是否繼續展延授權？"
        }
        
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .postpone_confirmAuthorization_2
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func checkPrescriptionStatus() {
        // 確認是否還有預約？
        var tempCodes: [String] = []
        
        hospitals.forEach {
            //let tmpStr: String = "\($0.partnerId)"
            //tempCodes.append(tmpStr)
            tempCodes.append($0.tenantId)
        }
        
        getPrescriptionsStatus(medicalType: "1", orgCodes: tempCodes)
    }
    
    
    @objc func customBarButtonTapped() {
        currentPostponeMode = .terminate
        checkPrescriptionStatus()
    }
    
    @objc override func popPresentedViewController() {
        onNoNeedAskPostpone?(true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AuthPostponeViewController {
    private func setItemView(hospitalName: String, addBottomLine: Bool, itemIndex: Int, isSelect: Bool) {
        // Note: Change to use TableView to implement ???
        let view = MedicalItemSelectView()
        
        view.itemText = hospitalName
        view.addBottomLine = addBottomLine
        view.currentItemType = .none
        view.isSelect = isSelect
        view.delegate = self
        view.currentIndex = itemIndex
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 54.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    // Note: Remove arrangedSubviews function
    func onRemove(_ view: MedicalItemSelectView) {
        if let first = self.itemListView.arrangedSubviews.first(where: { $0 === view }) {
            UIView.animate(withDuration: 0.3, animations: {
                first.isHidden = true
                first.removeFromSuperview()
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension AuthPostponeViewController: MedicalItemSelectViewDelegate {
    func selectMedicalItem(itemType: MedicalItemType, itemIndex: Int) {
        if itemIndex < hospitals.count {
            hospitals[itemIndex].isSelected = true
            checkIfEnableButton()
            
            if getSelectItemNumber() != hospitals.count {
                isAllSelectEnable = false
            } else {
                isAllSelectEnable = true
            }
        }
    }
    
    func deSelectMedicalItem(itemType: MedicalItemType, itemIndex: Int) {
        if itemIndex < hospitals.count {
            hospitals[itemIndex].isSelected = false
            checkIfEnableButton()
            
            if getSelectItemNumber() != hospitals.count {
                isAllSelectEnable = false
            } else {
                isAllSelectEnable = true
            }
        }
    }
}

extension AuthPostponeViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        //
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .postpone_cancelAuthorization_1 {
            showSecondAlert()
        } else if alertType == .postpone_cancelAuthorization_2 {
            // call API
            terminateAllMedicalAuth()
        } else if alertType == .postpone_confirmAuthorization_1 {
            // call API
            showConfirmPostponeAlert()
        } else if alertType == .postpone_confirmAuthorization_2 {
            currentAuthIds.removeAll()
            currentTerminateIds.removeAll()
            
            hospitals.forEach {
                if $0.isSelected {
                    currentAuthIds.append($0.medicalAuthId)
                } else {
                    currentTerminateIds.append($0.medicalAuthId)
                }
            }
            
            handleMedicalAuth(siyjOfd: currentAuthIds,
                              terminateIds: currentTerminateIds)
        } else {
            let storyboard = UIStoryboard(name: "AuthManagement", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AuthManageViewController") as! AuthManageViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AuthPostponeViewController {
    func terminateAllMedicalAuth() {
        currentTerminateIds.removeAll()
        
        hospitals.forEach {
            currentTerminateIds.append($0.medicalAuthId)
        }
        
        terminateMedicalAuth(siyjOfd: currentTerminateIds)
    }
    
    func getExpiredMedAuthList() {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let keychain = KeychainSwift()
        let idTokenForAPI: String = keychain.get("idToken") ?? ""
        
        SDKManager.sdk.getExpiredMedAuthList(idTokenForAPI) {
            (responseModel: PhiResponseModel<ExpiredMedAuthListRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let expiredMedAuthList = responseModel.data,
                      let expiredMedAuthInfos = expiredMedAuthList.dataArray else {
                    return
                }
                
                self.hospitals.removeAll()
                
                for i in 0 ..< expiredMedAuthInfos.count {
                    let dataItem: ExpiredMedAuthRspModel = expiredMedAuthInfos[i]
                    let hospitalItem: HospitalInfo = HospitalInfo(medicalAuthId: dataItem.medicalAuthId, partnerId: dataItem.partnerId, tenantId: dataItem.tenantId, partnerOrgName: dataItem.partnerOrgName, isSelected: true)
                    
                    self.hospitals.append(hospitalItem)
                }
                
                DispatchQueue.main.async {
                    if self.hospitals.count == 0 {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        alertViewController.delegate = self
                        alertViewController.alertLabel.text = "無法取得資料"
                        alertViewController.alertImageView.image = UIImage(named: "Error")
                        alertViewController.alertType = .none
                        self.present(alertViewController, animated: true, completion: nil)
                    } else {
                        for i in 0 ..< self.hospitals.count {
                            let hospitalItem: HospitalInfo = self.hospitals[i]
                            
                            if i == self.hospitals.count - 1 {
                                self.setItemView(hospitalName: hospitalItem.partnerOrgName, addBottomLine: false, itemIndex: i, isSelect: hospitalItem.isSelected)
                            } else {
                                self.setItemView(hospitalName: hospitalItem.partnerOrgName, addBottomLine: true, itemIndex: i, isSelect: hospitalItem.isSelected)
                            }
                        }
                        
                        self.isAllSelectEnable = true
                        
                        // ???
                        /*
                        if self.getSelectItemNumber() > 0 {
                            self.checkIfEnableButton()
                            self.isAllSelectEnable = true
                        }
                        */
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getExpiredMedAuthList()
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
    
    // checkmarx
    func terminateMedicalAuth(siyjOfd: [Int]) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let setupExpiredMedicalAuthReqInfo: SetupExpiredMedicalAuthModel = SetupExpiredMedicalAuthModel(medicalAuthIds: siyjOfd)
        SDKManager.sdk.terminateMedicalAuth(postModel: setupExpiredMedicalAuthReqInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "AuthManagement", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AuthManageViewController") as! AuthManageViewController
                    vc.hidesBottomBarWhenPushed = true
                    vc.needBackToRoot = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.terminateMedicalAuth(siyjOfd: siyjOfd)
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
    
    func handleMedicalAuth(siyjOfd: [Int], terminateIds: [Int]) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let handleExpiredMedicalAuthReqInfo: HandleExpiredMedAuthModel = HandleExpiredMedAuthModel(extendMedicalAuthIds: siyjOfd, terminateMedicalAuthIds: terminateIds)
        SDKManager.sdk.handleMedicalAuth(postModel: handleExpiredMedicalAuthReqInfo) {
            (responseModel: PhiResponseModel<NullModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                DispatchQueue.main.async {
                    let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                    alertViewController.delegate = self
                    alertViewController.alertLabel.text = "授權展延成功！"
                    self.present(alertViewController, animated: true, completion: nil)
                }
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.handleMedicalAuth(siyjOfd: siyjOfd, terminateIds: terminateIds)
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
    
    func getPrescriptionsStatus(medicalType: String, orgCodes: [String]) {
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let getPrescriptioStatusReqInfo: GetPrescriptionStatusModel = GetPrescriptionStatusModel(medicalType: medicalType, tenantIds: orgCodes)
        SDKManager.sdk.getPrescriptionStatus(postModel: getPrescriptioStatusReqInfo) {
            (responseModel: PhiResponseModel<PrescriptionStatusRspModel>) in
            
            if responseModel.success {
                guard let presStatusRspModel = responseModel.data else {
                    return
                }
                
                print("hasOngoingStatusPrescription=\(presStatusRspModel.hasOngoingStatusPrescription)!")
                
                if presStatusRspModel.hasOngoingStatusPrescription {
                    DispatchQueue.main.async {
                        self.showFirstAlert()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showSecondAlert()
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getPrescriptionsStatus(medicalType: medicalType, orgCodes: orgCodes)
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
}

extension AuthPostponeViewController: VerifyResultAlertVCDelegate {
    func clickBtn(alertType: VerifyResultAlertVC_Type) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
