//
//  MedLocationViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/21.
//

import UIKit
import KeychainSwift
import ProgressHUD
import GoogleMaps
import CoreLocation

class MedLocationViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet private weak var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.tableFooterView = UIView()
            tblView.backgroundColor = UIColor(hex: "#FAFAFA")
            tblView.separatorStyle = .none
            //tblView.allowsSelection = false
            tblView.rowHeight = UITableView.automaticDimension
            tblView.estimatedRowHeight = 2
            tblView.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet var containerView: UIView! // A UIView in which GMSMapView will be embedded
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var oneBtnContainerView: UIView!
    @IBOutlet weak var RcvMedOnSiteButton: UIButton!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var searchInputView: SearchInputView!
    
    private let cellIdentifier = "PharmacyInfoTViewCell"
    // for Test
    //var data = pharmacyCellViewModelSampleData()
    //var searchResultData = searchResultSampleData()
    var firstTimeData = [PharmacyCellViewModel]()
    var currentData = [PharmacyCellViewModel]()
    var medicalPartnerInfoList = [MedicalPartnerRspModel]()
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    var isReceiveMedicineFinish: Bool = false
    var locationManager: CLLocationManager!
    var mapView: GMSMapView!
    var lastIndexPath: IndexPath?
    //var currentLatitude: CLLocationDegrees?
    //var currentLongitude: CLLocationDegrees?
    var currentLocation: CLLocation?
    var selectedItem: PharmacyCellViewModel?
    var currentLatitude: Double = 0.0
    var currentLongitude: Double = 0.0
    var currentKeyWord: String = ""
    private var isFirstTime: Bool = true
    private var isFirstTimeSaveData: Bool = true
    // If no GPS, default center 國泰醫院 25.036983918473734, 121.55375274848689
    var noGPSLatitude: Double = 25.036983918473734
    var noGPSLongitude: Double = 121.55375274848689
    var currentPage = 0
    var isLoading = false // 是否正在載入數據
    var hasNextPage = false
    var searchTrigger: Bool = false
    var rollbackTrigger: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replaceBackBarButtonItem()
        //createRightBarButtonViaImage()
        // For Demo
        //currentData = data
        updateUI()
        updateGoogleMapUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData),
            name: .MedLocationVC_Reload,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadData() {
        if let location = self.currentLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
            mapView.animate(to: camera)
            mapView.animate(to: camera)
            
            self.rollBackToFirstTimeData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharingManager.sharedInstance.isMedLocationViewController = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        SharingManager.sharedInstance.isMedLocationViewController = false
        // checkmarx
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // checkmarx
        UIApplication.shared.isIdleTimerDisabled = true // 防止螢幕截圖或休眠
        
        if isFirstTime {
            if currentLatitude != 0.0 {
                self.searchTrigger = false
                self.requestSearchPharmacys(latitude: currentLatitude, longitude: currentLongitude, keyWord: self.currentKeyWord)
                
                isFirstTime = false
            }
        }
    }
    
    func updateGoogleMapUI() {
        // 初始化 CLLocationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 初始化 GMSMapView 並添加到 containerView 中
        mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self // 設置地圖視圖的代理
        self.containerView.addSubview(mapView)
        
        // 設置 mapView 的約束條件
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }
    
    func updateUI(fromSrvRsp: [PharmacyMapInfoRspModel]) {
        for i in 0 ..< fromSrvRsp.count {
            let srcItem: PharmacyMapInfoRspModel = fromSrvRsp[i]
            let dstCellItem: PharmacyCellViewModel = PharmacyCellViewModel(hospitalName: srcItem.name, distance: "\(srcItem.distance)", isReserve: srcItem.isPartner ? "可預約" : "", receiveMedicineTimes: srcItem.isLastReceive ? "前次領藥" : "", address: srcItem.address, contactPhone: srcItem.contactPhone, businessHours: srcItem.businessHours, pharmacyId: srcItem.id, latitude: srcItem.latitude, longitude: srcItem.longitude, isPartner: srcItem.isPartner, isSelectCell: false)
            dstCellItem.markerInfo = self.addMarker(at: CLLocationCoordinate2D(latitude: srcItem.latitude, longitude: srcItem.longitude), marketrTitle: srcItem.name, snippetText: srcItem.isPartner ? "可預約" : "")
            self.currentData.append(dstCellItem)
        }
        
        if currentData.count > 0 {
            self.hiddenNoNeedUI(enableHidden: true)
            self.tblView.reloadData()
            
            if self.searchTrigger {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            self.hiddenNoNeedUI(enableHidden: false)
        }
        
        // Save first time data
        if isFirstTimeSaveData {
            self.firstTimeData = self.currentData
            
            isFirstTimeSaveData = false
        }
    }
    
    @objc func customBarButtonTapped() {
        //let isSuccess = true
        let successMessage = "此功能尚未開放，敬請期待"
        //let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: "提醒"/*: "錯誤"*/,
                                      message: successMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createRightBarButtonViaImage() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(customBarButtonTapped), for: .touchUpInside)
        
        let customBarButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = customBarButton
    }
    
    func updateUI() {
        tblView.register(nibWithCellClass: PharmacyInfoTViewCell.self)
        
        refreshControl.addTarget(self, action: #selector(refreshCurrentData), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)
        
        //if self.getMedInfos.count > 0 {
        if currentData.count > 0 {
            self.hiddenNoNeedUI(enableHidden: true)
            self.tblView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            self.hiddenNoNeedUI(enableHidden: false)
        }
        
        buttonContainerView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        oneBtnContainerView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        firstButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        firstButton.layer.borderWidth = 1.0
        //secondButton.layer.borderColor = UIColor(hex: "#EDB935", alpha: 1)!.cgColor
        //secondButton.layer.borderWidth = 1.0
        //firstButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        //firstButton.layer.borderWidth = 1.0
        
        //shadowView.layer.cornerRadius = 12
        shadowView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        searchInputView.textField.delegate = self
        searchInputView.textField.keyboardType = .default
        searchInputView.delegate = self
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        tblView.isHidden = !enableHidden
    }
    
    @objc func refreshCurrentData() {
        refreshControl.endRefreshing()
        // ???
    }
    
    @IBAction func firstButtonAction(_ sender: UIButton) {
        // 現場領藥
        if let selectedItem = self.selectedItem {
            if selectedItem.isPartner {
                if !SharingManager.sharedInstance.apns_tenantId.isEmpty &&
                    !SharingManager.sharedInstance.apns_medicalType.isEmpty &&
                    !SharingManager.sharedInstance.apns_diagnosisNo.isEmpty &&
                    !SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                    let storyboard = UIStoryboard(name: "Prescription", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MedicineQRViewController") as! MedicineQRViewController
                    vc.hidesBottomBarWhenPushed = true
                    vc.needBackToRoot = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let storyboard = UIStoryboard(name: "PharmacyInfo", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "NotPartnerDoneViewController") as! NotPartnerDoneViewController
                vc.currentSelectedItem = self.selectedItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func secondButtonAction(_ sender: UIButton) {
        // 預約領藥
        let storyboard = UIStoryboard(name: "PharmacyInfo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmReservationViewController") as! ConfirmReservationViewController
        vc.currentSelectedItem = self.selectedItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToCenterLocationAction(_ sender: UIButton) {
        //if let currentLatitude = self.currentLatitude,
        //   let currentLongitude = self.currentLongitude {
        if let location = self.currentLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
            mapView.animate(to: camera)
            mapView.animate(to: camera)
            
            self.rollBackToFirstTimeData()
        }
    }
}

extension MedLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let pharmacyInfoCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PharmacyInfoTViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        /*
         if indexPath.row < medicalPartnerInfoList.count {
         hospitalItemCell.configureCell(title: medicalPartnerInfoList[indexPath.row].organizationName, buttonTitle: "")
         }
         */
        
        if indexPath.row < currentData.count {
            pharmacyInfoCell.configureCell(viewModel: currentData[indexPath.row])
        }
        return pharmacyInfoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Optional: deselect the cell after highlighting
        // tableView.deselectRow(at: indexPath, animated: true)
        
        if currentData[indexPath.row].isSelectCell {
            return
        }
        
        var currentIndexPath: IndexPath?
        
        for i in 0 ..< currentData.count {
            if currentData[i].isSelectCell {
                currentData[i].isSelectCell = false
                
                currentIndexPath = IndexPath(row: i, section: 0)
                break
            }
        }
        
        currentData[indexPath.row].isSelectCell = true
        
        // Save current item
        selectedItem = currentData[indexPath.row]
        
        if currentData[indexPath.row].isPartner {
            buttonContainerView.isHidden = false
            oneBtnContainerView.isHidden = true
            //firstButton.setTitle("現場領藥", for: .normal)
            //secondButton.setTitle("預約領藥", for: .normal)
        } else {
            buttonContainerView.isHidden = true
            oneBtnContainerView.isHidden = false
        }
        
        if indexPath.row < currentData.count {
            mapView.selectedMarker = self.currentData[indexPath.row].markerInfo
            // Animate to the marker
            if let markerInfo = self.currentData[indexPath.row].markerInfo {
                mapView.animate(toLocation: markerInfo.position)
            }
        }
        
        tableView.beginUpdates()
        if currentIndexPath != nil {
            tableView.reloadRows(at: [currentIndexPath!, indexPath], with: .automatic)
        } else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 146
     }
     */
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY + scrollViewHeight >= contentHeight - 100 { // 在接近底部时加载更多
            //loadData(page: currentPage)
            requestSearchPharmacys(latitude: self.currentLatitude,
                                   longitude: self.currentLongitude,
                                   keyWord: self.currentKeyWord)
        }
    }
    */
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentData.count - 1 {
            if self.hasNextPage && self.rollbackTrigger == false {
                self.searchTrigger = false
                requestSearchPharmacys(latitude: self.currentLatitude,
                                       longitude: self.currentLongitude,
                                       keyWord: self.currentKeyWord)
            } else {
                self.rollbackTrigger = false
            }
        }
    }
}

extension MedLocationViewController {
    func addMarker(at coordinate: CLLocationCoordinate2D, marketrTitle: String, snippetText: String) -> GMSMarker {
        // 初始化標記
        let marker = GMSMarker(position: coordinate)
        
        // 使用自定義的藥局圖標
        marker.icon = UIImage(named: "pharmacy_Blue")
        // 設置標記的資訊
        marker.title = marketrTitle
        marker.snippet = snippetText
        marker.tracksInfoWindowChanges = true
        // 將標記添加到地圖
        marker.map = mapView
        
        return marker
    }
    
    // CLLocationManagerDelegate 方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // 獲取用戶當前位置
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.currentLatitude = latitude
            self.currentLongitude = longitude
            //let radius: Double = 500.0 // 500 公尺
            
            //self.currentLatitude = location.coordinate.latitude
            //self.currentLongitude = location.coordinate.latitude
            self.currentLocation = location
            
            // 設置相機位置和縮放級別
            //let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: calculateZoomLevel(for: radius))
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
            mapView.camera = camera
            
            // 停止更新位置以節省電池
            locationManager.stopUpdatingLocation()
            
            if isFirstTime {
                if currentLatitude != 0.0 {
                    self.searchTrigger = false
                    self.requestSearchPharmacys(latitude: currentLatitude, longitude: currentLongitude, keyWord: self.currentKeyWord)
                    
                    isFirstTime = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    /*
     func calculateZoomLevel(for radius: Double) -> Float {
     let equatorLength: Double = 40075017.0
     let screenWidthInPixels: Double = 256.0
     let metersPerPixel: Double = equatorLength / screenWidthInPixels
     
     var zoomLevel: Double = log2(metersPerPixel / (radius * 2.0))
     zoomLevel = max(1, min(20, zoomLevel))
     
     return Float(zoomLevel)
     }
     */
    
    func processLocationPermissionsGranted() {
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
    }
    
    func processLocationPermissionsDenied() {
        let defaultLocation = CLLocationCoordinate2D(latitude: noGPSLatitude, longitude: noGPSLongitude)
        let camera = GMSCameraPosition.camera(withTarget: defaultLocation, zoom: 15.0)
        mapView.camera = camera
        
        //let marker = GMSMarker(position: defaultLocation)
        //marker.icon = GMSMarker.markerImage(with: .blue)
        //marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permissions granted
            processLocationPermissionsGranted()
            break
        case .denied, .restricted:
            // Permissions denied
            mapView.isMyLocationEnabled = false
            processLocationPermissionsDenied()
            break
        default:
            break
        }
    }
}

extension MedLocationViewController: GMSMapViewDelegate {
    // GMSMapViewDelegate 方法，用於處理標記點擊事件
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // 打印標記的資訊
        print("Marker title: \(marker.title ?? "No Title")")
        print("Marker snippet: \(marker.snippet ?? "No Snippet")")
        print("Marker position: \(marker.position)")
        
        // 返回 true 表示處理了標記點擊事件
        // return true
        // 地圖顯示藥局名稱
        
        // Animate to the marker
        mapView.animate(toLocation: marker.position)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        //let view = MarkerInfoView()
        //view.partnerNameText = marker.title ?? ""
        //view.statusText = marker.snippet ?? ""
        //let constraint1 = view.heightAnchor.constraint(lessThanOrEqualToConstant: 106.0)
        //constraint1.isActive = true
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 128, height: 80))
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8
        
        let imageView = UIImageView()
        if let image = UIImage(named: "Card_pharmacy info") {
            imageView.image = image
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: 128, height: 80)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
        let lbl1 = UILabel(frame: CGRect.init(x: 16, y: 14, width: view.frame.size.width - 26, height: 22))
        lbl1.text = marker.title
        lbl1.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 4, width: view.frame.size.width - 26, height: 18))
        lbl2.text = marker.snippet
        lbl2.font = UIFont.systemFont(ofSize: 13, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
}

extension MedLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 如果輸入為空或刪除操作，則直接傳回true
        if string.isEmpty {
            return true
        }
        
        if textField == searchInputView.textField {
            if let currentText = textField.text, currentText.count >= 64 {
                return false
            }
        }
        
        return true
    }
}

extension MedLocationViewController: SearchInputViewDelegate {
    func rollBackToFirstTimeData() {
        self.rollbackTrigger = true
        
        self.firstTimeData.forEach { $0.isSelectCell = false }
        
        for i in 0 ..< self.currentData.count {
            if let markInfo = self.currentData[i].markerInfo {
                markInfo.map = nil
            }
        }
        
        self.currentData = self.firstTimeData
        
        for i in 0 ..< self.currentData.count {
            if let markInfo = self.currentData[i].markerInfo {
                markInfo.map = mapView
            }
        }
        
        if self.currentData.count == 0 {
            self.hiddenNoNeedUI(enableHidden: false)
        } else {
            self.hiddenNoNeedUI(enableHidden: true)
            self.tblView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func processInpurSearchText(searchStr: String) {
        print("processInpurSearchText \(searchStr)!")
        
        self.currentKeyWord = searchStr
        
        if self.currentKeyWord.isEmpty {
            rollBackToFirstTimeData()
        } else {
            // reset to first page
            self.currentPage = 0
            self.searchTrigger = true
            self.rollbackTrigger = false
            requestSearchPharmacys(latitude: self.currentLatitude,
                                   longitude: self.currentLongitude,
                                   keyWord: self.currentKeyWord)
        }
        
        // For Demo
        /*
         ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
         ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
         ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
         ProgressHUD.dismiss()
         
         if searchStr.isEmpty {
         self.data.forEach { $0.isSelectCell = false }
         self.currentData = self.data
         } else {
         self.searchResultData.forEach { $0.isSelectCell = false }
         self.searchResultData.removeAll()
         self.currentData = self.searchResultData
         }
         
         if self.currentData.count == 0 {
         self.hiddenNoNeedUI(enableHidden: false)
         } else {
         self.hiddenNoNeedUI(enableHidden: true)
         self.tblView.reloadData()
         let indexPath = IndexPath(row: 0, section: 0)
         self.tblView.scrollToRow(at: indexPath, at: .top, animated: true)
         }
         }
         */
    }
}

extension MedLocationViewController {
    func requestSearchPharmacys(latitude: Double, longitude: Double, keyWord: String = "") {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        /*
         var medicalData: MedicalRecordRspModel?
         
         if let currentMedicalRecordModel = SharingManager.sharedInstance.currentMedicalRecordModel {
         medicalData = currentMedicalRecordModel
         }
         */
        /*
        guard let medicalData = medicalData else {
            self.isLoading = false
            ProgressHUD.dismiss()
            return
        }
        */
        
        if SharingManager.sharedInstance.apns_tenantId.isEmpty ||
            SharingManager.sharedInstance.apns_medicalType.isEmpty ||
            SharingManager.sharedInstance.apns_diagnosisNo.isEmpty ||
            SharingManager.sharedInstance.apns_prescriptionNo.isEmpty {
                self.isLoading = false
                ProgressHUD.dismiss()
                return
        }
        
        let reqInfo: SearchPharmacyModel = SearchPharmacyModel(tenantId: SharingManager.sharedInstance.apns_tenantId, medicalType: SharingManager.sharedInstance.apns_medicalType, diagnosisNo: SharingManager.sharedInstance.apns_diagnosisNo, prescriptionNo: SharingManager.sharedInstance.apns_prescriptionNo, latitude: latitude, longitude: longitude, keyword: keyWord, page: currentPage)
        SDKManager.sdk.searchPharmacy(postModel: reqInfo) {
            (responseModel: PhiResponseModel<PharmacyMapInfoListRspModel>) in
            
            if responseModel.success {
                guard let pharmacyMapInfoListModel = responseModel.data,
                      let pharmacyMapInfos = pharmacyMapInfoListModel.dataArray else {
                    self.isLoading = false
                    return
                }
                
                self.hasNextPage = pharmacyMapInfoListModel.hasNextPage
                
                DispatchQueue.main.async {
                    if self.currentPage == 0 {
                        // 移除舊的標記
                        for i in 0 ..< self.currentData.count {
                            if let markInfo = self.currentData[i].markerInfo {
                                markInfo.map = nil
                            }
                        }
                        self.currentData.removeAll()
                        self.updateUI(fromSrvRsp: pharmacyMapInfos)
                    } else {
                        self.updateUI(fromSrvRsp: pharmacyMapInfos)
                    }
                    
                    if pharmacyMapInfoListModel.hasNextPage {
                        self.currentPage += 1
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.requestSearchPharmacys(latitude: self.currentLatitude, longitude: self.currentLongitude, keyWord: self.currentKeyWord)
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
            
            self.isLoading = false
            ProgressHUD.dismiss()
        }
    }
}
