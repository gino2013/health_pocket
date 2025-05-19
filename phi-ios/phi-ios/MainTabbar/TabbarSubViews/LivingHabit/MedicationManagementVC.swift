//
//  MedicationManagementVC.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/3.
//

import UIKit
import KeychainSwift
import ProgressHUD
import FSCalendar
import PanModal
//import RealmSwift

class MedicationManagementVC: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet private weak var tblView: UITableView! {
        didSet {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.tableFooterView = UIView()
            tblView.backgroundColor = UIColor(hex: "#FAFAFA")
            tblView.separatorStyle = .none
            //tblView.allowsSelection = false
            tblView.showsVerticalScrollIndicator = false
            tblView.rowHeight = UITableView.automaticDimension
            tblView.estimatedRowHeight = 24
            /*
             if #available(iOS 15.0, *) {
             tblView.sectionHeaderTopPadding = 0
             }
             */
        }
    }
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var AddMedicineButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentSelectLabel: UILabel!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var todayButton: UIButton!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        // 設置 locale 為中文
        // formatter.locale = Locale(identifier: "zh_CN")
        // 設置日期格式
        // formatter.dateFormat = "EEEE M月d日"
    
        return formatter
    }()
    
    var selectedDate: Date? {
        didSet {
            // 格式化器，用來將日期轉換為字串
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            // 取得今天的日期字串
            let todayString = dateFormatter.string(from: Date())
            
            // 將 selectedDate 轉換為日期字串
            if let selectedDate = selectedDate {
                let selectedDateString = dateFormatter.string(from: selectedDate)
                
                // 比較兩個字串
                if selectedDateString == todayString {
                    todayButton.isHidden = true
                } else {
                    todayButton.isHidden = false
                }
            } else {
                todayButton.isHidden = false
            }
        }
    }
    
    private let sectionIdentifier = "ReminderSectionTVCell"
    private let cellIdentifier = "ReminderTViewCell"
    private let smallCellIdentifier = "SmallReminderTViewCell"
    var refreshControl = UIRefreshControl()
    var retryExecuted: Bool = false
    var sections: [ReminderSection] = reminderCellViewModelSampleData()
    var sectionExtDict: [String: [ReminderSectionExt]] = [:]
    var showPanModal: Bool = false
    var reminderInfoList: [(date: String, timeGroups: [ReminderTimeGroupRspModel])] = []
    var currentLimitStartDate: String = ""
    var currentLimitEndDate: String = ""
    var rangeDayNumber: Int = 7
    var canCallAPI: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        createRightBarButtonViaImage(imageName: "Add")
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showPanModal {
            presentPanModal(TransientAlertViewController(alertTitle: "已新增成功！"))
            showPanModal = false
        }
        
        if canCallAPI {
            callAllAPIsConcurrently() {
                DispatchQueue.main.async {
                    if let selectedDate = self.selectedDate {
                        if let sectionExts = self.sectionExtDict[self.dateFormatter.string(from: selectedDate)] {
                            if sectionExts.count > 0 {
                                self.hiddenNoNeedUI(enableHidden: true)
                                self.tblView.reloadData()
                            } else {
                                self.hiddenNoNeedUI(enableHidden: false)
                            }
                        } else {
                            self.hiddenNoNeedUI(enableHidden: false)
                        }
                    }
                    
                    ProgressHUD.dismiss()
                    
                    // K_0802_2024, add
                    if SharingManager.sharedInstance.isLocalNotificationMode {
                        self.processLocalNotificationFlow()
                    }
                }
            }
        } else {
            canCallAPI = true
        }
    }
    
    func updateUI() {
        tblView.register(nibWithCellClass: ReminderSectionTVCell.self)
        tblView.register(nibWithCellClass: ReminderTViewCell.self)
        tblView.register(nibWithCellClass: SmallReminderTViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshApiInfos), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tblView.addSubview(refreshControl)
        
        emptyImageView.isHidden = true
        noteLabel.isHidden = true
        AddMedicineButton.isHidden = true
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        
        calendar.select(Date())
        selectedDate = Date()
        currentSelectLabel.text = getCustomizedDateForShow(source: selectedDate!)
        
        self.calendar.accessibilityIdentifier = "calendar"
        self.calendar.locale = Locale(identifier: "zh_CN")
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        self.calendar.appearance.weekdayTextColor = UIColor(hex: "#34393D", alpha: 1.0)
        self.calendar.appearance.headerTitleColor = UIColor.darkGray
        self.calendar.appearance.eventDefaultColor = UIColor.green
        self.calendar.appearance.selectionColor = UIColor(hex: "#3399DB", alpha: 1.0)
        self.calendar.appearance.headerDateFormat = "yyyy-MM";
        self.calendar.appearance.todayColor = UIColor(hex: "#989898", alpha: 1.0)
        //self.calendar.appearance.todayColor = UIColor.red
        //self.calendar.appearance.titleTodayColor = UIColor(hex: "#34393D", alpha: 1.0)
        self.calendar.appearance.titleTodayColor = .white
        //self.calendar.appearance.todaySelectionColor = UIColor.clear
        self.calendar.appearance.borderRadius = 1.0
        self.calendar.appearance.borderRadius = 1.0
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        todayView.addShadow(
            topOpacity: 0, /* 不添加頂部陰影 */
            bottomColor: UIColor.black, bottomOpacity: 0.9, bottomRadius: 16, bottomOffset: CGSize(width: 0, height: 4),
            leftColor: UIColor.black, leftOpacity: 0.9, leftRadius: 16, leftOffset: CGSize(width: -4, height: 0),
            rightColor: UIColor.black, rightOpacity: 0.9, rightRadius: 16, rightOffset: CGSize(width: 4, height: 0)
        )
        
        yearLabel.text = "\(Calendar.current.component(.year, from: Date()))年"
        
        todayButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        todayButton.layer.borderWidth = 1.0
    }
    
    func hiddenNoNeedUI(enableHidden: Bool) {
        emptyImageView.isHidden = enableHidden
        noteLabel.isHidden = enableHidden
        AddMedicineButton.isHidden = enableHidden
        tblView.isHidden = !enableHidden
    }
    
    func processLocalNotificationFlow() {
        if let sectionExts = self.sectionExtDict[SharingManager.sharedInstance.localNotif_reminderDate] {
            
            var rspItem: ReminderRspModel?
            var tmpSection: Int = 0
            var tmpRow: Int = 0
            
            for i in 0 ..< sectionExts.count {
                let sectionItem: ReminderSectionExt = sectionExts[i]
                
                if sectionItem.title == SharingManager.sharedInstance.localNotif_reminderTime {
                    
                    for j in 0 ..< sectionItem.items.count {
                        let item: ReminderCellViewModelExt = sectionItem.items[j]
                        
                        if item.reminderInfo.reminderSettingId == SharingManager.sharedInstance.localNotif_reminderSettingId.integer && item.reminderInfo.reminderTimeSettingId == SharingManager.sharedInstance.localNotif_reminderTimeSettingId.integer {
                            rspItem = item.reminderInfo
                            tmpSection = item.cellSection
                            tmpRow = item.cellIndex
                            break
                        }
                    }
                }
            }
            
            if let rspItemInstance = rspItem {
                let storyboard = UIStoryboard(name: "MedManageSetting", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MedicineTakingSettingVC") as! MedicineTakingSettingVC
                
                vc.rspItem = rspItemInstance
                vc.currentSectionExtsSection = tmpSection
                vc.currentSectionExtsRow = tmpRow
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        SharingManager.sharedInstance.isLocalNotificationMode = false
    }
    
    @objc func refreshApiInfos() {
        refreshControl.endRefreshing()
        // ???
    }
    
    func pushToAddMedicinePage() {
        // push to add medicine
        let storyboard = UIStoryboard(name: "ManualSetting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ManualSettingStep1ViewController") as! ManualSettingStep1ViewController
        vc.delegate_MedicationManagementVC = self
        
        SharingManager.sharedInstance.currentSetReminderMode = .manual
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc override func rightBarButtonTapped() {
        pushToAddMedicinePage()
    }
    
    @IBAction func addMedicineAction(_ sender: UIButton) {
        pushToAddMedicinePage()
    }
    
    @IBAction func clickTodayAction(_ sender: UIButton) {
        self.selectedDate = Date()
        calendar.select(self.selectedDate)
        currentSelectLabel.text = getCustomizedDateForShow(source: self.selectedDate ?? Date())
        useDateToUpdateUI()
    }
    
    func useDateToUpdateUI() {
        if let selectedDate = self.selectedDate {
            
            if let isInRange = DateTimeUtils.isDateInRange(dateString: dateFormatter.string(from: selectedDate), startDateString: self.currentLimitStartDate, endDateString: self.currentLimitEndDate) {
                print(isInRange ? "日期在範圍內" : "日期不在範圍內")
                
                if isInRange {
                    if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate)] {
                        if sectionExts.count > 0 {
                            self.hiddenNoNeedUI(enableHidden: true)
                            self.tblView.reloadData()
                        } else {
                            self.hiddenNoNeedUI(enableHidden: false)
                        }
                    } else {
                        self.hiddenNoNeedUI(enableHidden: false)
                    }
                } else {
                    // call API
                    if let dateRange = DateTimeUtils.getDateRange(from: dateFormatter.string(from: selectedDate), daysBefore: self.rangeDayNumber, daysAfter: self.rangeDayNumber) {
                        
                        self.currentLimitStartDate = dateRange.startDate
                        self.currentLimitEndDate = dateRange.endDate
                        
                        /*
                        if ReminderNotificationDataManager.shared.shouldUseCache() {
                            // 使用cache數據
                            /*
                             need fix crash
                            if let reminders = ReminderNotificationDataManager.shared.fetchRemindersFromCache(startDate: dateRange.startDate, endDate: dateRange.endDate) {
                                // updateUI(with: reminders)
                            }
                            */
                        } else {
                        */
                            // 從API獲取數據
                            self.getReminderList(startDate: dateRange.startDate, endDate: dateRange.endDate, completion: {}, singleMode: true)
                        //}
                    } else {
                        print("Invalid date input.")
                    }
                }
            } else {
                print("日期格式錯誤")
            }
        }
    }
    
    // FSCalendar
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func getCustomizedDateForShow(source: Date) -> String {
        let phiDateFormatter = DateFormatter()
        
        // 設置 locale 為中文
        phiDateFormatter.locale = Locale(identifier: "zh_CN")
        // 設置日期格式
        phiDateFormatter.dateFormat = "M月d日"
        // 獲取星期幾
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "zh_CN")
        weekdayFormatter.dateFormat = "EEEE"
        let weekdayString = weekdayFormatter.string(from: source)
        
        // K_0816_2024, modify
        // 自定義字典將 "星期" 替換為 "週"
        // let customWeekday = weekdayString.replacingOccurrences(of: "星期", with: "週")
        // let finalString = "\(customWeekday)  \(formattedDate)"
        
        // 格式化日期
        let formattedDate = phiDateFormatter.string(from: source)
        // 12月15日 星期五
        let finalString = "\(formattedDate) \(weekdayString)"
        
        print("getCustomizedDateForShow :: \(finalString)")
        return finalString
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("did select date \(self.dateFormatter.string(from: date))")
        
        //let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        //print("selected dates is \(selectedDates)")
        
        selectedDate = date
        
        /*
         if monthPosition == .next || monthPosition == .previous {
         calendar.setCurrentPage(date, animated: true)
         }
         */
        currentSelectLabel.text = getCustomizedDateForShow(source: date)
        
        useDateToUpdateUI()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //print("\(self.dateFormatter.string(from: calendar.currentPage))")
        
        guard let selectedDate = selectedDate else { return }
        
        let currentPage = calendar.currentPage
        let weekday = Calendar.current.component(.weekday, from: selectedDate)
        
        // 計算新的選中日期
        if let newSelectedDate = Calendar.current.date(bySetting: .weekday, value: weekday, of: currentPage) {
            self.selectedDate = newSelectedDate
            calendar.select(newSelectedDate)
            
            currentSelectLabel.text = getCustomizedDateForShow(source: newSelectedDate)
            //self.view.layoutIfNeeded()
            
            useDateToUpdateUI()
        }
    }
    
    // FSCalendarDelegateAppearance
    private func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleFor date: Date) -> String? {
        if calendar.scope == .week {
            let dateFormatter = DateFormatter()
            
            // 設置 locale 為中文
            dateFormatter.locale = Locale(identifier: "zh_CN")
            
            // dateFormatter.dateFormat = "d"  // 使用日期格式化器显示日期
            
            // 設置日期格式為星期幾的縮寫
            dateFormatter.dateFormat = "EEE"
            
            let title = dateFormatter.string(from: date)
            print("Title for date: \(date) is \(title)")
            return title
        }
        return nil
    }
    
    // 其他必要的 FSCalendarDataSource 方法
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}

extension MedicationManagementVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //return sections.count
        if let selectedDate = self.selectedDate {
            if let sections = sectionExtDict[dateFormatter.string(from: selectedDate)] {
                return sections.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sections[section].items.count + 1 // +1 for the fake section
        if let selectedDate = self.selectedDate {
            if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate)] {
                return sectionExts[section].items.count + 1
            }
        }
        return 0
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return sections[section].title
     }
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let reminderSection = tableView.dequeueReusableCell(withIdentifier: sectionIdentifier, for: indexPath) as? ReminderSectionTVCell else {
                fatalError("Issue dequeuing \(sectionIdentifier)")
            }
            
            if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate!)] {
                reminderSection.sectionTitleLabel.text = sectionExts[indexPath.section].title
                return reminderSection
            }
            return reminderSection
            
        } else {
            guard let smallReminderItemCell = tableView.dequeueReusableCell(withIdentifier: smallCellIdentifier, for: indexPath) as? SmallReminderTViewCell else {
                fatalError("Issue dequeuing \(smallCellIdentifier)")
            }
            
            guard let reminderItemCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReminderTViewCell else {
                fatalError("Issue dequeuing \(cellIdentifier)")
            }
            
            /*
            // let item = sections[indexPath.section].items[indexPath.row]
            // -1 because the first row is the FakeSectionCell
            let item = sections[indexPath.section].items[indexPath.row - 1]
            */
            
            if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate!)] {
                let item = sectionExts[indexPath.section].items[indexPath.row - 1]
                
                if item.reminderInfo.subTitle.isEmpty {
                    smallReminderItemCell.configureCell(viewModelExt: item)
                    smallReminderItemCell.delegate = self
                    return smallReminderItemCell
                } else {
                    reminderItemCell.configureCell(viewModelExt: item)
                    reminderItemCell.delegate = self
                    return reminderItemCell
                }
            }
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            // click FakeSection, return
            return
        }
        
        if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate!)] {
            let item: ReminderCellViewModelExt = sectionExts[indexPath.section].items[indexPath.row - 1]
            let rspItem: ReminderRspModel = item.reminderInfo
            
            let storyboard = UIStoryboard(name: "MedManageSetting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MedicineTakingSettingVC") as! MedicineTakingSettingVC
            
            vc.rspItem = rspItem
            vc.currentSectionExtsSection = indexPath.section
            vc.currentSectionExtsRow = indexPath.row - 1
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            // FakeSectionCell 高度
            return 56
        } else {
            return 112
        }
    }
    */
}

extension MedicationManagementVC: ManualSettingStep2ViewControllerDelegate {
    func popPanModalAddSuccessAlert() {
        presentPanModal(TransientAlertViewController(alertTitle: "已新增成功！"))
    }
    
    func popPanModalSaveAllSuccessAlert() {
        presentPanModal(TransientAlertViewController(alertTitle: "已儲存成功！"))
    }
    
    func popPanModalDeleteAllSuccessAlert() {
        presentPanModal(TransientAlertViewController(alertTitle: "已刪除成功！"))
    }
}

extension MedicationManagementVC {
    func dumpSrvDataToSectionsData(from: [(date: String, timeGroups: [ReminderTimeGroupRspModel])]) {
        
        let selectDateStr = dateFormatter.string(from: selectedDate ?? Date())
        let dateRange: [String] = DateTimeUtils.getDateRange(from: selectDateStr, daysBefore: self.rangeDayNumber, daysAfter: self.rangeDayNumber)
        self.sectionExtDict.removeAll()
        
        for i in 0 ..< dateRange.count {
            let srcDate: String = dateRange[i]
            
            for j in 0 ..< from.count {
                let fromItem: (date: String, timeGroups: [ReminderTimeGroupRspModel]) = from[j]
                
                if srcDate == fromItem.date {
                    /*
                    var timeTitle: String
                    var items: [ReminderRspModel]
                    */
                    let timeGroups: [ReminderTimeGroupRspModel] = fromItem.timeGroups
                    var timeTitle: String = ""
                    var infoTmps: [ReminderCellViewModelExt] = []
                    var sectionArray: [ReminderSectionExt] = []
                    
                    for k in 0 ..< timeGroups.count {
                        timeTitle = timeGroups[k].timeTitle
                        let reminderItems: [ReminderRspModel] = timeGroups[k].items
                        
                        infoTmps.removeAll()
                        
                        for l in 0 ..< reminderItems.count {
                            let item: ReminderRspModel = reminderItems[l]
                            var isLast: Bool = false
                            var imageName: String = "Pill_Default"
                            
                            if l == (reminderItems.count - 1) {
                                isLast = true
                            }
                            
                            if item.isChecked {
                                imageName = "Pill_Done"
                            } else if DateTimeUtils.isReminderPassed(reminderDate: item.reminderDate, reminderTime: item.reminderTime) {
                                imageName = "Pill_None"
                            }
                            
                            let reminderModel: ReminderCellViewModelExt = ReminderCellViewModelExt(cellIndex: l, cellSection: k, iconImageName: imageName, addBottomLine: !isLast, reminderInfo: item)
                            
                            infoTmps.append(reminderModel)
                        }
                        
                        let reminderSecExt: ReminderSectionExt = ReminderSectionExt(title: timeTitle, items: infoTmps)
                        sectionArray.append(reminderSecExt)
                        self.sectionExtDict[srcDate] = sectionArray
                    }
                }
            }
        }
    }
    
    func useSelDateToGetSectionInfo(srcDate: String) -> [ReminderSectionExt] {
        var result: [ReminderSectionExt] = []
        
        if let sectionExts = sectionExtDict[srcDate] {
            result = sectionExts
        }
        
        return result
    }
    
    /*
    func saveResponseToRealm(_ response: [(date: String, timeGroups: [ReminderTimeGroupRspModel])]) {
        
        let realm = try! Realm() // 每個執行緒要使用自己的 Realm 實例
        
        let realmRecords = response.map { record in
            let realmTimeGroups = record.timeGroups.map { timeGroup in
                let realmItems = timeGroup.items.map { item in
                    let realmReminder = RealmReminder()
                    realmReminder.type = item.type
                    realmReminder.isSingleTimeSetting = item.isSingleTimeSetting
                    realmReminder.reminderDate = item.reminderDate
                    realmReminder.reminderTime = item.reminderTime
                    realmReminder.reminderSettingId = item.reminderSettingId
                    realmReminder.reminderTimeSettingId = item.reminderTimeSettingId
                    realmReminder.reminderSingleTimeSettingId = item.reminderSingleTimeSettingId
                    realmReminder.isChecked = item.isChecked
                    realmReminder.checkTime = item.checkTime
                    realmReminder.isEnded = item.isEnded
                    realmReminder.title = item.title
                    realmReminder.subTitle = item.subTitle
                    realmReminder.tags.append(objectsIn: item.tags)
                    
                    let realmRecordMedicineInfo = RealmReminderRecordMedicine()
                    realmRecordMedicineInfo.reminderRecordMedicineInfoId = item.reminderRecordMedicineInfo.reminderRecordMedicineInfoId
                    realmRecordMedicineInfo.takenTime = item.reminderRecordMedicineInfo.takenTime
                    realmReminder.reminderRecordMedicineInfo = realmRecordMedicineInfo
                    
                    let realmSettingMedicineInfo = RealmReminderMedicineInfo()
                    realmSettingMedicineInfo.medicineName = item.reminderSettingMedicineInfo.medicineName
                    realmSettingMedicineInfo.medicineNameAlias = item.reminderSettingMedicineInfo.medicineNameAlias
                    realmSettingMedicineInfo.dose = item.reminderSettingMedicineInfo.dose
                    realmSettingMedicineInfo.doseUnits = item.reminderSettingMedicineInfo.doseUnits
                    realmSettingMedicineInfo.useTime = item.reminderSettingMedicineInfo.useTime
                    realmReminder.reminderSettingMedicineInfo = realmSettingMedicineInfo
                    
                    return realmReminder
                }
                let realmTimeGroup = RealmReminderTimeGroup()
                realmTimeGroup.timeTitle = timeGroup.timeTitle
                realmTimeGroup.items.append(objectsIn: realmItems)
                return realmTimeGroup
            }
            let realmRecordGroup = RealmReminderRecordGroup()
            realmRecordGroup.date = record.date
            realmRecordGroup.timeGroups.append(objectsIn: realmTimeGroups)
            return realmRecordGroup
        }
        
        // 寫入資料
        try! realm.write {
            realm.add(realmRecords, update: .modified)
        }
    }
    */
    
    func getReminderList(startDate: String, endDate: String, completion: @escaping () -> Void, singleMode: Bool = false) {
        if singleMode {
            ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
            ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
            ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        }
        
        let reqInfo: GetReminderRecordsModel = GetReminderRecordsModel(startDate: startDate, endDate: endDate)
        SDKManager.sdk.getReminderRecords(reqInfo) {
            (responseModel: PhiResponseModel<ReminderRecordGroupRspModel>) in
            
            if responseModel.success {
                guard let reminderRecordGroupRsp = responseModel.data else {
                    return
                }
                
                /*
                DispatchQueue.main.async {
                    ReminderNotificationDataManager.shared.setLastFetchTime(Date())
                    //ReminderNotificationDataManager.shared.saveReminders(reminderRecords: self.reminderInfoList)
                    self.saveResponseToRealm(reminderRecordGroupRsp.reminderRecords)
                }
                */
                
                self.reminderInfoList = reminderRecordGroupRsp.reminderRecords
                self.dumpSrvDataToSectionsData(from: self.reminderInfoList)
                
                if singleMode {
                    DispatchQueue.main.async {
                        if let selectedDate = self.selectedDate {
                            if let sectionExts = self.sectionExtDict[self.dateFormatter.string(from: selectedDate)] {
                                if sectionExts.count > 0 {
                                    self.hiddenNoNeedUI(enableHidden: true)
                                    self.tblView.reloadData()
                                } else {
                                    self.hiddenNoNeedUI(enableHidden: false)
                                }
                            } else {
                                self.hiddenNoNeedUI(enableHidden: false)
                            }
                        }
                    }
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getReminderList(startDate: startDate, endDate: endDate, completion: {
                        // ???
                        DispatchQueue.main.async {
                            if let selectedDate = self.selectedDate {
                                if let sectionExts = self.sectionExtDict[self.dateFormatter.string(from: selectedDate)] {
                                    if sectionExts.count > 0 {
                                        self.hiddenNoNeedUI(enableHidden: true)
                                        self.tblView.reloadData()
                                    } else {
                                        self.hiddenNoNeedUI(enableHidden: false)
                                    }
                                } else {
                                    self.hiddenNoNeedUI(enableHidden: false)
                                }
                            }
                            
                            ProgressHUD.dismiss()
                        }
                    })
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
            
            if singleMode {
                ProgressHUD.dismiss()
            }
            
            completion()
        }
    }
    
    func callAllAPIsConcurrently(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        dispatchGroup.enter()
        dispatchQueue.async {
            // 取得今天的日期並轉換為字串
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let today = dateFormatter.string(from: Date())

            // 傳入今天日期，取得範圍的第一個和最後一個日期
            if let dateRange = DateTimeUtils.getDateRange(from: today, daysBefore: self.rangeDayNumber, daysAfter: self.rangeDayNumber) {
                print("Start Date: \(dateRange.startDate), End Date: \(dateRange.endDate)")
                
                self.currentLimitStartDate = dateRange.startDate
                self.currentLimitEndDate = dateRange.endDate
                
                /*
                if ReminderNotificationDataManager.shared.shouldUseCache() {
                    // 使用cache數據
                    /*
                     need fix crash
                    if let reminders = ReminderNotificationDataManager.shared.fetchRemindersFromCache(startDate: dateRange.startDate, endDate: dateRange.endDate) {
                        // updateUI(with: reminders)
                        dispatchGroup.leave()
                    }
                    */
                } else {
                */
                    // 從API獲取數據
                    self.getReminderList(startDate: dateRange.startDate, endDate: dateRange.endDate, completion: {
                        dispatchGroup.leave()
                    })
                //}
            } else {
                print("Invalid date input.")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        dispatchQueue.async {
            LocalNotificationUtils.syncAndGetReminderNotifications {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All API calls are complete.")
            completion()
        }
    }
}

extension MedicationManagementVC {
    func editSingleReminder(itemSection: Int, itemIndex: Int) {
        // 處理編輯提醒的邏輯
        let storyboard = UIStoryboard(name: "ReminderEdit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditSingleReminderViewController") as! EditSingleReminderViewController
        
        if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate!)] {
            let item: ReminderCellViewModelExt = sectionExts[itemSection].items[itemIndex]
            let rspItem: ReminderRspModel = item.reminderInfo
            
            vc.delegate = self
            vc.rspItem = rspItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func editAllReminder(itemSection: Int, itemIndex: Int) {
        getReminderSetting(itemSection: itemSection, itemIndex: itemIndex)
    }
    
    func clickMoreBtn(itemSection: Int, itemIndex: Int) {
        print("reminder = \(itemSection), \(itemIndex)!")
        
        guard let selectedDate = self.selectedDate else {
            return
        }
        
        let actionSheet = UIAlertController()
        let editSingleReminderAction = UIAlertAction(title: "修改單次提醒", style: .default) { _ in
            self.editSingleReminder(itemSection: itemSection, itemIndex: itemIndex)
        }
        let editAllReminderAction = UIAlertAction(title: "修改全部提醒", style: .default) { _ in
            self.editAllReminder(itemSection: itemSection, itemIndex: itemIndex)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(editSingleReminderAction)
        actionSheet.addAction(editAllReminderAction)
        /*
        if let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate)] {
            let sectionExt: ReminderSectionExt = sectionExts[itemSection]
            
            if sectionExt.items.count > 1 {
                actionSheet.addAction(editAllReminderAction)
            }
            
        }
        */
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension MedicationManagementVC: ReminderTViewCellDelegate {
    func didTapMoreButtonAtCellIndex(index: Int, section: Int) {
        print("didTapMoreButtonAtCellIndex :: section:\(section) index:\(index)")
        clickMoreBtn(itemSection: section, itemIndex: index)
    }
}

extension MedicationManagementVC: MedicineTakingSettingVCDelegate {
    func processReminderRecordMedicineInfo(isChecked: Bool, reminderInfo: ReminderRspModel, checkTime: String, section: Int, row: Int) {
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        if !isChecked {
            let request: CreateReminderRecordModel = CreateReminderRecordModel(remindDate: reminderInfo.reminderDate, reminderSettingId: reminderInfo.reminderSettingId, reminderTimeSettingId: reminderInfo.reminderTimeSettingId, reminderSingleTimeSettingId: reminderInfo.reminderSingleTimeSettingId, takenTime: checkTime)
            SDKManager.sdk.createReminderRecordMedicineInfo(request) {
                (responseModel: PhiResponseModel<ReminderRecordInfoRspModel>) in
                
                ProgressHUD.dismiss()
                
                if responseModel.success {
                    guard let reminderRecordInfo = responseModel.data else {
                        return
                    }
                    
                    if let sectionExts = self.sectionExtDict[self.dateFormatter.string(from: self.selectedDate!)] {
                        let item: ReminderCellViewModelExt = sectionExts[section].items[row]
                        
                        item.reminderInfo.reminderRecordMedicineInfo.reminderRecordMedicineInfoId = reminderRecordInfo.reminderRecordMedicineInfoId
                        item.reminderInfo.isChecked = true
                        item.reminderInfo.checkTime = checkTime
                        item.iconImageName = "Pill_Done"
                        
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                            self.canCallAPI = false
                            self.presentPanModal(TransientAlertViewController(alertTitle: "已服用完畢！"))
                        }
                    }
                    
                } else {
                    print("errorCode=\(responseModel.errorCode ?? "")!")
                    print("message=\(responseModel.message ?? "")!")
                    
                    self.handleAPIError(response: responseModel, retryAction: {
                        // 重試 API 呼叫
                        self.processReminderRecordMedicineInfo(isChecked: isChecked, reminderInfo: reminderInfo, checkTime: checkTime, section: section, row: row)
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
        } else {
            let request: DeleteReminderRecordModel = DeleteReminderRecordModel(remindDate: reminderInfo.reminderDate, reminderSettingId: reminderInfo.reminderSettingId, reminderTimeSettingId: reminderInfo.reminderTimeSettingId, reminderSingleTimeSettingId: reminderInfo.reminderSingleTimeSettingId, reminderRecordMedicineInfoId: reminderInfo.reminderRecordMedicineInfo.reminderRecordMedicineInfoId)
            SDKManager.sdk.deleteReminderRecordMedicineInfo(request) {
                (responseModel: PhiResponseModel<ReminderRecordInfoRspModel>) in
                
                ProgressHUD.dismiss()
                
                if responseModel.success {
                    guard let _ = responseModel.data else {
                        return
                    }
                    
                    if let sectionExts = self.sectionExtDict[self.dateFormatter.string(from: self.selectedDate!)] {
                        let item: ReminderCellViewModelExt = sectionExts[section].items[row]
                        
                        item.reminderInfo.isChecked = false
                        item.reminderInfo.checkTime = ""
                        item.iconImageName = "Pill_Default"
                        
                        if DateTimeUtils.isReminderPassed(reminderDate: reminderInfo.reminderDate, reminderTime: reminderInfo.reminderTime) {
                            item.iconImageName = "Pill_None"
                        }
                        
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                            self.canCallAPI = false
                            self.presentPanModal(TransientAlertViewController(alertTitle: "已回復！"))
                        }
                    }
                    
                } else {
                    print("errorCode=\(responseModel.errorCode ?? "")!")
                    print("message=\(responseModel.message ?? "")!")
                    
                    self.handleAPIError(response: responseModel, retryAction: {
                        // 重試 API 呼叫
                        self.processReminderRecordMedicineInfo(isChecked: isChecked, reminderInfo: reminderInfo, checkTime: checkTime, section: section, row: row)
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
}

extension MedicationManagementVC: EditSingleReminderViewControllerDelegate {
    func popPanModalSaveSuccessAlert() {
        //canCallAPI = false
        presentPanModal(TransientAlertViewController(alertTitle: "已儲存成功!"))
    }
    
    func popPanModalDeleteSuccessAlert() {
        //canCallAPI = false
        presentPanModal(TransientAlertViewController(alertTitle: "已刪除成功!"))
    }
}

// Edit All
extension MedicationManagementVC {
    func getReminderSetting(itemSection: Int, itemIndex: Int) {
        guard let sectionExts = sectionExtDict[dateFormatter.string(from: selectedDate!)] else {
            return
        }
        
        ProgressHUD.colorAnimation = UIColor(hex: "#5CADE2", alpha: 1.0)!
        ProgressHUD.colorStatus = UIColor(hex: "#858585", alpha: 1.0)!
        ProgressHUD.animate(CommonSettings.ProgressHUDText, .activityIndicator, interaction: false)
        
        let item: ReminderCellViewModelExt = sectionExts[itemSection].items[itemIndex]
        let rspItem: ReminderRspModel = item.reminderInfo
        let reqInfo: GetReminderSettingModel = GetReminderSettingModel(remindDate: rspItem.reminderDate, reminderSettingId: rspItem.reminderSettingId)
        SDKManager.sdk.getReminderSetting(postModel: reqInfo) {
            (responseModel: PhiResponseModel<ReminderSettingRspModel>) in
            
            if responseModel.success {
                guard let reminderSettingRspInfo = responseModel.data else {
                    return
                }
                
                DispatchQueue.main.async {
                    SharingManager.sharedInstance.currentSetReminderMode = .edit
                    
                    let storyboard = UIStoryboard(name: "ManualSetting", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ManualSettingStep2ViewController") as! ManualSettingStep2ViewController
                    
                    vc.reminderSettingRspItem = reminderSettingRspInfo
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else {
                print("errorCode=\(responseModel.errorCode ?? "")!")
                print("message=\(responseModel.message ?? "")!")
                
                self.handleAPIError(response: responseModel, retryAction: {
                    // 重試 API 呼叫
                    self.getReminderSetting(itemSection: itemSection, itemIndex: itemIndex)
                }, fallbackAction: {
                    // 後備行動，例如顯示錯誤提示
                    DispatchQueue.main.async {
                        let alertViewController = UINib.load(nibName: "VerifyResultAlertVC") as! VerifyResultAlertVC
                        //alertViewController.delegate = self
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
