//
//  AppointStep1ViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/3.
//

import UIKit
import ProgressHUD

enum AppointmentStatus: Int {
    case step1
    case step2
    case step3
    case step4
}

enum ReserveAction: String {
    /* 1:預約 2:取消預約 */
    case none = "0"
    case confirm = "1"
    case cancel = "2"
}

class AppointStep1ViewController: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stepUIView: UIView!
    @IBOutlet weak var step1ImageView: UIImageView!
    @IBOutlet weak var step1textLabel: UILabel!
    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var step2ImageView: UIImageView!
    @IBOutlet weak var step2textLabel: UILabel!
    @IBOutlet weak var centerLine: UIView!
    @IBOutlet weak var step3ImageView: UIImageView!
    @IBOutlet weak var step3textLabel: UILabel!
    @IBOutlet weak var lastLine: UIView!
    @IBOutlet weak var step4ImageView: UIImageView!
    @IBOutlet weak var step4textLabel: UILabel!
    
    @IBOutlet weak var InPreparationView: UIView!
    @IBOutlet weak var mainCenterImageView: UIImageView!
    @IBOutlet weak var mainCenterLabel: UILabel!
    @IBOutlet weak var firstInformationView: UIView!
    @IBOutlet weak var firstInfoLabel: UILabel!
    @IBOutlet weak var secondInformationView: UIView!
    @IBOutlet weak var secondInfoLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var lineViewInTopView: UIView!
    @IBOutlet weak var infoViewInTopView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var itemListBaseView: UIView!
    @IBOutlet weak var itemListView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var blueFoldImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var finishInfoView: UIView!
    
    @IBOutlet weak var testBtn1: UIButton!
    @IBOutlet weak var testBtn2: UIButton!
    @IBOutlet weak var testBtn3: UIButton!
    @IBOutlet weak var testBtn4: UIButton!
    
    @IBOutlet weak var finishInfoLabel: UILabel!
    @IBOutlet weak var info2Label: UILabel!
    
    //private var departments: [DepartmentInfo] = []
    private var prescriptionInfos: [PrescriptionInfo] = []
    /*
    private var prescriptionInfos: [PrescriptionInfo] = [
        PrescriptionInfo(medicineName: "停敏膜衣錠", medicineAlias: "待設定", dose: 3, doseUnits: "顆", useTime: "PC", usagetimeDesc: "每日三次", takingTime: "飯後", prescriptionCode: "每日三次飯後", frequencyTimes: 3),
        PrescriptionInfo(medicineName: "止痛藥", medicineAlias: "待設定", dose: 3, doseUnits: "顆", useTime: "PC", usagetimeDesc: "每日二次", takingTime: "飯後", prescriptionCode: "每日二次飯後", frequencyTimes: 2),
        PrescriptionInfo(medicineName: "止咳藥水", medicineAlias: "待設定", dose: 3, doseUnits: "顆", useTime: "PC", usagetimeDesc: "每日三次", takingTime: "飯後", prescriptionCode: "每日三次飯後", frequencyTimes: 3),
        PrescriptionInfo(medicineName: "處方藥4", medicineAlias: "待設定", dose: 3, doseUnits: "顆", useTime: "PC", usagetimeDesc: "每日二次", takingTime: "飯後", prescriptionCode: "每日二次飯後", frequencyTimes: 2),
        PrescriptionInfo(medicineName: "處方藥5", medicineAlias: "待設定", dose: 3, doseUnits: "顆", useTime: "PC", usagetimeDesc: "每日四次", takingTime: "飯後", prescriptionCode: "每日四次飯後", frequencyTimes: 4)
    ]
    */
    /*
     var currenttenantId: String = ""
     var currentPrescriptionId: String = ""
     var currentDiagnosisNo: String = ""
     var currentMedicalType: String = ""
     */
    var medicinesInfoList: [MedicinesRspModel]?
    var retryExecuted: Bool = false
    // 儲存之前的屏幕亮度
    var previousBrightness: CGFloat = 0.0
    var showDetail: Bool = false {
        didSet {
            if showDetail {
                blueFoldImageView.image = UIImage(named: "bluefold")
                itemListBaseView.isHidden = false
                subTitleLabel.isHidden = false
            } else {
                blueFoldImageView.image = UIImage(named: "blueunfold")
                itemListBaseView.isHidden = true
                subTitleLabel.isHidden = true
            }
        }
    }
    var currentStep: AppointmentStatus = .step1 {
        didSet {
            if currentStep == .step3 {
                // 將屏幕亮度設置為最大值
                UIScreen.main.brightness = 1.0
                createRightBarButton(isMostBrightness: true)
            } else {
                removeRightBarButton()
            }
        }
    }
    var selectedItem: PharmacyCellViewModel?
    var needBackToRoot: Bool = false
    var qrCodeAccessToken: String = ""
    var prescriptionDetailInfo: PrescriptionDetailRspModel?
    var receiveRecordId: Int = 0
    var onNoNeedReSendAPI: ((_ reSendFlag: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "處方箋"
        
        // 儲存當前的屏幕亮度
        previousBrightness = UIScreen.main.brightness
        replaceBackBarButtonItem()
        updateUI()
        reloadData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData),
            name: .AppointVC_Reload,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharingManager.sharedInstance.isAppointStep1ViewController = true
        
        if SharingManager.sharedInstance.isPushNotificationMode {
            SharingManager.sharedInstance.isPushNotificationMode = false
            reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentStep == .step3 {
            // 將屏幕亮度設置為最大值
            UIScreen.main.brightness = 1.0
            createRightBarButton(isMostBrightness: true)
        } else {
            removeRightBarButton()
        }
    }
    
    @objc func reloadData() {
        callAllAPIsConcurrently() {
            DispatchQueue.main.async {
                self.updateUIviaSrvData()
            }
            
            if let prescriptionDetailInfo = self.prescriptionDetailInfo {
                
                DispatchQueue.main.async {
                    self.rangeLabel.text = "\(prescriptionDetailInfo.opdDate)-\(prescriptionDetailInfo.endDate)"
                    self.dayLabel.text = "\(prescriptionDetailInfo.perReceiveDays)日"
                    self.timesLabel.text = "\(prescriptionDetailInfo.receivedTimes)/\(prescriptionDetailInfo.refillTimes)次"
                }
                
                if prescriptionDetailInfo.receiveStatus == "1" {
                    if prescriptionDetailInfo.isReserving {
                        // 1-送出預約, 2-預約已接受, 3-待領藥,
                        if prescriptionDetailInfo.reservingStepInfo.reservingStep == "1" || prescriptionDetailInfo.reservingStepInfo.reservingStep == "" {
                            // 送出預約
                            self.currentStep = .step1
                            DispatchQueue.main.async {
                                self.updateUIviaStep(reservationPharmacyName: prescriptionDetailInfo.reservingStepInfo.reservationPharmacyName)
                            }
                        } else if prescriptionDetailInfo.reservingStepInfo.reservingStep == "2" {
                            self.currentStep = .step2
                            DispatchQueue.main.async {
                                self.updateUIviaStep(reservationPharmacyName: prescriptionDetailInfo.reservingStepInfo.reservationPharmacyName, reservationEstimatePreparedDate: prescriptionDetailInfo.reservingStepInfo.reservationEstimatePreparedDate)
                            }
                        } else if prescriptionDetailInfo.reservingStepInfo.reservingStep == "3" {
                            // show QRCode
                            // get QRCode URL
                            if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                                !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                                !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                                !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                                self.getMedicineQrcode(
                                    orgCode: SharingManager.sharedInstance.apns_tenantId,
                                    prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo,
                                    medicalType: SharingManager.sharedInstance.apns_medicalType,
                                    diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo) {
                                        DispatchQueue.main.async {
                                            self.updateQRCodeviaSrvData(accessToken: self.qrCodeAccessToken)
                                            self.currentStep = .step3
                                            self.updateUIviaStep(reservationPharmacyName: prescriptionDetailInfo.reservingStepInfo.reservationPharmacyName)
                                            // 將屏幕亮度設置為最大值
                                            UIScreen.main.brightness = 1.0
                                            self.createRightBarButton(isMostBrightness: true)
                                        }
                                    }
                            }
                        }
                    }
                } else if prescriptionDetailInfo.receiveStatus == "4" {
                    // show 空白 QRcode
                    self.currentStep = .step4
                    DispatchQueue.main.async {
                        self.updateUIviaStep(receivedTimes: prescriptionDetailInfo.receivedTimes, reservationPharmacyName: prescriptionDetailInfo.reservingStepInfo.reservationPharmacyName)
                    }
                }
            }
            
            print("currentStep = \(self.currentStep)!")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SharingManager.sharedInstance.isAppointStep1ViewController = false
        
        if currentStep == .step3 {
            // 恢復到之前儲存的屏幕亮度
            UIScreen.main.brightness = previousBrightness
            createRightBarButton(isMostBrightness: false)
        }
    }
    
    func updateUI() {
        topView.isHidden = true
        
        // 移除所有 subView
        for subview in itemListView.arrangedSubviews {
            itemListView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // 設置 delegate
        scrollView.delegate = self
        
        /*
         if let medicalRecordInfo = SharingManager.sharedInstance.currentMedicalRecordModel {
         rangeLabel.text = "\(medicalRecordInfo.opdDate)-\(medicalRecordInfo.datetime)"
         dayLabel.text = "\(medicalRecordInfo.perReceiveDays)日"
         timesLabel.text = "\(medicalRecordInfo.receivedTimes)/\(medicalRecordInfo.refillTimes)次"
         }
         */
        
        topView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        topView.layer.borderWidth = 1.0
        
        InPreparationView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        InPreparationView.layer.borderWidth = 1.0
        //InPreparationView.isHidden = true
        
        //addShadow(sourceView: middleView)
        //middleView.layer.cornerRadius = 12
        middleView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        middleView.addTopShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        //itemListBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        bottomView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        bottomView.addBottomShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        configureButtons(enable: true)
        
        //testBtn1.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        //testBtn1.layer.borderWidth = 1.0
        testBtn1.makeTransparent()
        //testBtn2.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        //testBtn2.layer.borderWidth = 1.0
        testBtn2.makeTransparent()
        //testBtn3.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        //testBtn3.layer.borderWidth = 1.0
        testBtn3.makeTransparent()
        //testBtn4.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        //testBtn4.layer.borderWidth = 1.0
        testBtn4.makeTransparent()
        
        cancelButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        cancelButton.layer.borderWidth = 1.0
    }
    
    func updateUIviaSrvData() {
        for i in 0 ..< self.prescriptionInfos.count {
            let prescriptionInfo: PrescriptionInfo = self.prescriptionInfos[i]
            
            if i == self.prescriptionInfos.count - 1 {
                self.setItemView(prescriptionInfo: prescriptionInfo, addBottomLine: false, itemIndex: i)
            } else {
                self.setItemView(prescriptionInfo: prescriptionInfo, addBottomLine: true, itemIndex: i)
            }
        }
        
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.layoutIfNeeded()
        
        showDetail = false
    }
    
    func updateUIviaStep(receivedTimes: Int = 0,
                         reservationPharmacyName: String = "",
                         reservationEstimatePreparedDate: String = "") {
        switch currentStep {
        case .step1:
            topView.isHidden = true
            mainCenterImageView.image = UIImage(named: "doc_3")
            mainCenterLabel.text = "預約已送出"
            InPreparationView.isHidden = false
            secondInformationView.isHidden = true
            finishInfoView.isHidden = true
            firstInfoLabel.text = reservationPharmacyName
            removeRightBarButton()
        case .step2:
            topView.isHidden = true
            mainCenterImageView.image = UIImage(named: "doctor_2")
            mainCenterLabel.text = "藥局已接單"
            InPreparationView.isHidden = false
            secondInformationView.isHidden = false
            finishInfoView.isHidden = true
            cancelButton.isHidden = true
            firstInfoLabel.text = reservationPharmacyName
            secondInfoLabel.text = reservationEstimatePreparedDate
            // update step status UI
            step1ImageView.image = UIImage(named: "step_v")
            step1textLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
            step1textLabel.textColor = UIColor(hex: "#858585")
            firstLine.backgroundColor = UIColor(hex: "#C7C7C7")
            step2ImageView.image = UIImage(named: "step")
            step2textLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
            step2textLabel.textColor = UIColor(hex: "#2E8BC7")
            centerLine.backgroundColor = UIColor(hex: "#C0DFF4")
            removeRightBarButton()
        case .step3:
            topView.isHidden = false
            InPreparationView.isHidden = true
            finishInfoView.isHidden = true
            cancelButton.isHidden = true
            firstInfoLabel.text = reservationPharmacyName
            info2Label.text = reservationPharmacyName
            // update step status UI
            step1ImageView.image = UIImage(named: "step_v")
            step1textLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
            step1textLabel.textColor = UIColor(hex: "#858585")
            firstLine.backgroundColor = UIColor(hex: "#C7C7C7")
            step2ImageView.image = UIImage(named: "step_v")
            step2textLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
            step2textLabel.textColor = UIColor(hex: "#858585")
            centerLine.backgroundColor = UIColor(hex: "#C7C7C7")
            step3ImageView.image = UIImage(named: "step")
            step3textLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
            step3textLabel.textColor = UIColor(hex: "#2E8BC7")
            lastLine.backgroundColor = UIColor(hex: "#C0DFF4")
            // 將屏幕亮度設置為最大值
            UIScreen.main.brightness = 1.0
            createRightBarButton(isMostBrightness: true)
        case .step4:
            topView.isHidden = false
            QRCodeImageView.image = UIImage(named: "grayQRCode")
            infoViewInTopView.isHidden = true
            InPreparationView.isHidden = true
            finishInfoView.isHidden = false
            cancelButton.isHidden = true
            finishInfoLabel.text = "第\(receivedTimes)次領藥完成"
            firstInfoLabel.text = reservationPharmacyName
            info2Label.text = reservationPharmacyName
            // update step status UI
            step1ImageView.image = UIImage(named: "step_v")
            step1textLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
            step1textLabel.textColor = UIColor(hex: "#858585")
            firstLine.backgroundColor = UIColor(hex: "#C7C7C7")
            step2ImageView.image = UIImage(named: "step_v")
            step2textLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
            step2textLabel.textColor = UIColor(hex: "#858585")
            centerLine.backgroundColor = UIColor(hex: "#C7C7C7")
            step3ImageView.image = UIImage(named: "step_v")
            step3textLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
            step3textLabel.textColor = UIColor(hex: "#858585")
            lastLine.backgroundColor = UIColor(hex: "#C7C7C7")
            step4ImageView.image = UIImage(named: "step")
            step4textLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
            step4textLabel.textColor = UIColor(hex: "#2E8BC7")
            removeRightBarButton()
        }
    }
    
    func updateQRCodeviaSrvData(accessToken: String) {
        guard accessToken != "" else {
            return
        }
        
        if let qrCodeImage = QRCodeUtils.generateQRCode(from: accessToken, size: CGSize(width: 120, height: 120)) {
            // 使用 qrCodeImage 來顯示 QRCode 圖像
            QRCodeImageView.image = qrCodeImage
        } else {
            print("Failed to generate QRCode")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 強制水平偏移量為零
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
    }
    
    func addShadow(sourceView: UIView) {
        // Auto layout, variables, and unit scale are not yet supported
        //var view = UIView()
        //view.frame = CGRect(x: 0, y: 0, width: 327, height: 152)
        let shadows = UIView()
        shadows.frame = sourceView.frame
        shadows.clipsToBounds = false
        sourceView.addSubview(shadows)
        
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 8)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0.153, green: 0.173, blue: 0.18, alpha: 0.05).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 10
        layer0.shadowOffset = CGSize(width: 0, height: 2)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        
        let shapes = UIView()
        shapes.frame = sourceView.frame
        shapes.clipsToBounds = true
        sourceView.addSubview(shapes)
        
        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
        
        shapes.layer.cornerRadius = 8
        shapes.layer.borderWidth = 1
        shapes.layer.borderColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1).cgColor
    }
    
    @objc func customBarButtonTapped() {
        if UIScreen.main.brightness == 1.0 {
            // 恢復到之前儲存的屏幕亮度
            UIScreen.main.brightness = previousBrightness
            createRightBarButton(isMostBrightness: false)
        } else {
            UIScreen.main.brightness = 1.0
            createRightBarButton(isMostBrightness: true)
        }
    }
    
    func createRightBarButton(isMostBrightness: Bool) {
        let titleLabel = UILabel()
        
        if isMostBrightness {
            titleLabel.text = "標準亮度"
        } else {
            titleLabel.text = "最大亮度"
        }
        titleLabel.textColor = UIColor(hex: "#34393D")
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customBarButtonTapped))
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.isUserInteractionEnabled = true
        
        // 建立 UIBarButtonItem，並設定樣式為 .plain，並將自訂的 UILabel 設定為自訂視圖
        let customBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = customBarButton
    }
    
    func removeRightBarButton() {
        navigationItem.rightBarButtonItem = nil
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
    
    @IBAction func clickToSeeDetailAction(_ sender: UIButton) {
        showDetail = !showDetail
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.messageLabel.text = "是否確認取消預約"
        alertViewController.delegate = self
        alertViewController.isKeyButtonLeft = false
        alertViewController.confirmButton.setTitle("取消", for: .normal)
        alertViewController.cancelButton.setTitle("確認", for: .normal)
        alertViewController.alertType = .cancel_appointment
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "GetMedicine", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GetMedRecordViewController") as! GetMedRecordViewController
        vc.isReceiveMedicineFinish = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func testBtn1Action(_ sender: UIButton) {
        currentStep = .step2
        updateUIviaStep()
    }
    
    @IBAction func testBtn2Action(_ sender: UIButton) {
        // 藥局取消
        let alertViewController = UINib.load(nibName: "TwoButtonAlertVC") as! TwoButtonAlertVC
        alertViewController.delegate = self
        alertViewController.messageLabel.text = "藥局已取消預約，請重新預約或現場領藥\n(取消理由：預約藥品無庫存)"
        alertViewController.isKeyButtonLeft = true
        alertViewController.confirmButton.setTitle("我知道了", for: .normal)
        alertViewController.cancelButton.isHidden = true
        alertViewController.alertType = .none
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func testBtn3Action(_ sender: UIButton) {
        currentStep = .step3
        updateUIviaStep()
    }
    
    @IBAction func PreparationDoneAction(_ sender: UIButton) {
        currentStep = .step4
        
        DispatchQueue.main.async {
            let alertViewController = UINib.load(nibName: "ShowResultAlertVC") as! ShowResultAlertVC
            alertViewController.alertLabel.text = "領藥完成"
            self.present(alertViewController, animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                alertViewController.dismiss(animated: true) {
                    self.updateUIviaStep()
                    
                    /*
                    let storyboard = UIStoryboard(name: "MedResult", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MedResultViewController") as! MedResultViewController
                    vc.isReceiveMedicineFinish = true
                    vc.receiveRecordId = 1  /* hardcode for test */
                    self.navigationController?.pushViewController(vc, animated: true)
                    */
                }
            }
        }
    }
    
    @objc override func popPresentedViewController() {
        onNoNeedReSendAPI?(false)
        
        if needBackToRoot {
            needBackToRoot = false
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AppointStep1ViewController {
    func setItemView(prescriptionInfo: PrescriptionInfo, addBottomLine: Bool, itemIndex: Int) {
        let view = MedicineNote()
        
        view.medicineNameText = prescriptionInfo.medicineName
        view.useDaysText = "\(prescriptionInfo.dose)"
        view.numberOfDayText = prescriptionInfo.usagetimeDesc
        view.addBottomLine = addBottomLine
        
        let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 106.0)
        constraint1.isActive = true
        self.itemListView.addArrangedSubview(view)
        self.view.layoutIfNeeded()
    }
    
    // Note: Remove arrangedSubviews function
    func onRemove(_ view: MedicineNote) {
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

extension AppointStep1ViewController: TwoButtonAlertVCDelegate {
    func clickLeftBtn(alertType: TwoButton_Type) {
        if alertType == .cancel_appointment {
            
        } else {
            // Note: SharingManager.sharedInstance.currentMedicalRecordModel MUST be not null
            //if SharingManager.sharedInstance.currentMedicalRecordModel != nil {
            if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                let storyboard = UIStoryboard(name: "Prescription", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MedicineQRViewController") as! MedicineQRViewController
                vc.hidesBottomBarWhenPushed = true
                vc.needBackToRoot = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func clickRightBtn(alertType: TwoButton_Type) {
        if alertType == .cancel_appointment {
            // call API
            if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                cancelReservation(
                    orgCode: SharingManager.sharedInstance.apns_tenantId,
                    prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo,
                    medicalType: SharingManager.sharedInstance.apns_medicalType,
                    diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo,
                    pharmacyId: "")
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AppointStep1ViewController {
    func getPrescriptionMedicines(orgCode: String, prescriptionId: String,
                                  medicalType: String, diagnosisNo: String,
                                  completion: @escaping () -> Void) {
        //ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        //ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        //ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let getPrescriptionReqInfo: GetPrescriptionModel = GetPrescriptionModel(tenantId: orgCode, prescriptionNo: prescriptionId, medicalType: medicalType, diagnosisNo: diagnosisNo)
        SDKManager.sdk.getPrescriptionMedicines(postModel: getPrescriptionReqInfo) {
            (responseModel: PhiResponseModel<MedicinesListRspModel>) in
            
            // ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let medicinesListRspModel = responseModel.data,
                      let medicinesDataArray = medicinesListRspModel.dataArray else {
                    completion()
                    return
                }
                
                self.medicinesInfoList = medicinesDataArray
                
                // For test
                self.prescriptionInfos.removeAll()
                
                for i in 0 ..< self.medicinesInfoList!.count {
                    let medicinesItem: MedicinesRspModel = self.medicinesInfoList![i]
                    let takingTime: String = takingTimeCodeMapping[medicinesItem.useTime] ?? "飯後"
                    
                    let prescriptionItem: PrescriptionInfo = PrescriptionInfo(medicineName: medicinesItem.brandName, medicineAlias: "", dose: medicinesItem.dose, doseUnits: medicinesItem.doseUnits, useTime: medicinesItem.useTime, usagetimeDesc: medicinesItem.usagetimeDesc, takingTime: takingTime, prescriptionCode: "\(medicinesItem.usagetimeDesc)\(takingTime)", frequencyTimes: medicinesItem.frequencyTimes)
                    self.prescriptionInfos.append(prescriptionItem)
                }
                
                // For reminder
                SharingManager.sharedInstance.currAutoImportPrescriptionInfos = self.prescriptionInfos
                
                /*
                 DispatchQueue.main.async {
                 self.updateUIviaSrvData()
                 self.updateUIviaStep()
                 }
                 */
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getPrescriptionMedicines(orgCode: orgCode, prescriptionId: prescriptionId, medicalType: medicalType, diagnosisNo: diagnosisNo, completion: completion)
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
    
    func getMedicineQrcode(orgCode: String, prescriptionId: String,
                           medicalType: String, diagnosisNo: String,
                           completion: @escaping () -> Void) {
        //ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        //ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        //ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let getPrescriptionReqInfo: GetPrescriptionModel = GetPrescriptionModel(tenantId: orgCode, prescriptionNo: prescriptionId, medicalType: medicalType, diagnosisNo: diagnosisNo)
        SDKManager.sdk.getPrescriptionQRCode(postModel: getPrescriptionReqInfo) {
            (responseModel: PhiResponseModel<PrescriptionQRCodeRspModel>) in
            
            //ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let prescriptionQRCodeRspModel = responseModel.data else {
                    return
                }
                
                self.qrCodeAccessToken = prescriptionQRCodeRspModel.accessToken
                print("qrCodeAccessToken=\(self.qrCodeAccessToken)!")
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getMedicineQrcode(
                        orgCode: SharingManager.sharedInstance.apns_tenantId,
                        prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo,
                        medicalType: SharingManager.sharedInstance.apns_medicalType,
                        diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo) {
                            if let prescriptionDetailInfo = self.prescriptionDetailInfo {
                                DispatchQueue.main.async {
                                    self.updateQRCodeviaSrvData(accessToken: self.qrCodeAccessToken)
                                    self.currentStep = .step3
                                    self.updateUIviaStep(reservationPharmacyName: prescriptionDetailInfo.reservingStepInfo.reservationPharmacyName)
                                    // 將屏幕亮度設置為最大值
                                    UIScreen.main.brightness = 1.0
                                    self.createRightBarButton(isMostBrightness: true)
                                }
                            }
                        }
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
            
            completion()
        }
    }
    
    func getPrescription(orgCode: String, prescriptionId: String,
                         medicalType: String, diagnosisNo: String,
                         completion: @escaping () -> Void) {
        //ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        //ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        //ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let getPrescriptionReqInfo: GetPrescriptionModel = GetPrescriptionModel(tenantId: orgCode, prescriptionNo: prescriptionId, medicalType: medicalType, diagnosisNo: diagnosisNo)
        SDKManager.sdk.getPrescription(postModel: getPrescriptionReqInfo) {
            (responseModel: PhiResponseModel<PrescriptionDetailRspModel>) in
            
            //ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let prescriptionDetailRspModel = responseModel.data else {
                    completion()
                    return
                }
                
                self.prescriptionDetailInfo = prescriptionDetailRspModel
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getPrescriptionMedicines(orgCode: orgCode, prescriptionId: prescriptionId, medicalType: medicalType, diagnosisNo: diagnosisNo, completion: completion)
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
}

extension AppointStep1ViewController {
    func callAllAPIsConcurrently(isPushNotiyMode: Bool = false, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        dispatchGroup.enter()
        dispatchQueue.async {
            if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                self.getPrescriptionMedicines(
                    orgCode: SharingManager.sharedInstance.apns_tenantId,
                    prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo,
                    medicalType: SharingManager.sharedInstance.apns_medicalType,
                    diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo) {
                        dispatchGroup.leave()
                    }
            }
        }
        
        dispatchGroup.enter()
        dispatchQueue.async {
            if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                self.getPrescription(
                    orgCode: SharingManager.sharedInstance.apns_tenantId,
                    prescriptionId: SharingManager.sharedInstance.apns_prescriptionNo,
                    medicalType: SharingManager.sharedInstance.apns_medicalType,
                    diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo) {
                        dispatchGroup.leave()
                    }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All API calls are complete.")
            ProgressHUD.dismiss()
            completion()
        }
    }
}

extension AppointStep1ViewController {
    func cancelReservation(orgCode: String, prescriptionId: String,
                           medicalType: String, diagnosisNo: String,
                           pharmacyId: String) {
        /*
         guard let selectedItem = self.selectedItem else {
         print("Warning! no pharmacyId!")
         return
         }
         */
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let reservationModelReqInfo: PrescriptionReservationModel = PrescriptionReservationModel(tenantId: orgCode, medicalType: medicalType, diagnosisNo: diagnosisNo, prescriptionNo: prescriptionId, pharmacyId: "", action: ReserveAction.cancel.rawValue)
        SDKManager.sdk.prescriptionReservation(postModel: reservationModelReqInfo) {
            (responseModel: PhiResponseModel<PrescriptionReservationRspModel>) in
            
            ProgressHUD.dismiss()
            
            if responseModel.success {
                guard let _ = responseModel.data else {
                    return
                }
                
                // self.receiveRecordIdFromSrv = receiveRspModel.receiveRecordId
                
                // 自動刷新 現場領藥QRCode
                DispatchQueue.main.async {
                    // Note: SharingManager.sharedInstance.currentMedicalRecordModel MUST be not null
                    if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                        !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                        !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                        !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                        let storyboard = UIStoryboard(name: "Prescription", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MedicineQRViewController") as! MedicineQRViewController
                        vc.hidesBottomBarWhenPushed = true
                        vc.needBackToRoot = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.cancelReservation(
                        orgCode: orgCode,
                        prescriptionId: prescriptionId,
                        medicalType: medicalType,
                        diagnosisNo: diagnosisNo, pharmacyId: "")
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
