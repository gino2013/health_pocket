//
//  AddSportTargetVC.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/21.
//

import UIKit
import ProgressHUD

class AddSportTargetVC: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var infoTableView: UITableView! {
        didSet {
            infoTableView.dataSource = self
            infoTableView.delegate = self
            infoTableView.tableFooterView = UIView()
            //infoTableView.backgroundColor = UIColor(hex: "#FAFAFA")
            infoTableView.separatorStyle = .none
            //historyTableView.allowsSelection = false
            //infoTableView.rowHeight = UITableView.automaticDimension
            //infoTableView.estimatedRowHeight = 2
            infoTableView.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let bannerItems = [
        SportInfoCellViewModel(cellIndex: 0, cellSection: 0, iconImageName: "export_1", mainTitle: "井九", subTitle: "1.5小時", isCustomized: false),
        SportInfoCellViewModel(cellIndex: 1, cellSection: 0, iconImageName: "sport_3", mainTitle: "自主訓練1", subTitle: "2.5小時", isCustomized: true),
        SportInfoCellViewModel(cellIndex: 2, cellSection: 0, iconImageName: "sport_3", mainTitle: "自主訓練2", subTitle: "3.5小時", isCustomized: true),
        SportInfoCellViewModel(cellIndex: 3, cellSection: 0, iconImageName: "sport_3", mainTitle: "自主訓練3", subTitle: "4.5小時", isCustomized: true)
    ]
    private let cellIdentifier = "SportBasicTViewCell"
    var retryExecuted: Bool = false
    let infoModels = [
        SportBasicCellViewModel(cellIndex: 0, cellSection: 0, iconImageName: "Walk", mainTitle: "散步", subTitle: "subTitle 0", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 1, cellSection: 0, iconImageName: "RaceWalking", mainTitle: "快走", subTitle: "subTitle 1", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 2, cellSection: 0, iconImageName: "Run", mainTitle: "慢跑", subTitle: "subTitle 2", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 3, cellSection: 0, iconImageName: "Swimming", mainTitle: "游泳", subTitle: "subTitle 3", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 4, cellSection: 0, iconImageName: "Biking", mainTitle: "騎腳踏車", subTitle: "subTitle 4", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 5, cellSection: 0, iconImageName: "Aerobic_exercise", mainTitle: "有氧舞蹈", subTitle: "subTitle 5", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 6, cellSection: 0, iconImageName: "Workout", mainTitle: "重量訓練", subTitle: "subTitle 6", infoText: "", addBottomLine: true),
        SportBasicCellViewModel(cellIndex: 7, cellSection: 0, iconImageName: "DIY_Menu_blue", mainTitle: "其他運動", subTitle: "subTitle 7", infoText: "", addBottomLine: false),]

    override func viewDidLoad() {
        super.viewDidLoad()
        replaceBackBarButtonItem()
        updateUI()
    }

    func updateUI() {
        baseView.layer.cornerRadius = 12
        baseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        setupBannerCollectionView()
        setupInfoTableView()
    }
    
    // MARK: - Setup CollectionView
    private func setupBannerCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 226, height: bannerCollectionView.frame.height) // 確保高度與 UICollectionView 高度一致
        layout.minimumLineSpacing = 10 // 設置行間距
        layout.minimumInteritemSpacing = 0 // 設置項目之間的間距為 0，防止 item 捲動時橫向溢出
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24) // 設定左右兩邊的間距為24
            
        bannerCollectionView.collectionViewLayout = layout
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.showsHorizontalScrollIndicator = false
        
        let nib = UINib(nibName: "SportInfoCollectionCell", bundle: nil)
        bannerCollectionView.register(nib, forCellWithReuseIdentifier: "SportInfoCollectionCell")

    }
    
    // MARK: - Setup TableView
    private func setupInfoTableView() {
        infoTableView.register(nibWithCellClass: SportBasicTViewCell.self)
    }
    
    func updateTableViewHeight() {
        DispatchQueue.main.async {
            self.infoTableView.layoutIfNeeded()
            let contentHeight = self.infoTableView.contentSize.height
            self.tblViewHeightConstraint.constant = contentHeight
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AddSportTargetVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportInfoCollectionCell", for: indexPath) as! SportInfoCollectionCell
        
        //let model = data[indexPath.row]
        //cell.configureCell(viewModel: model)
        cell.configureCell(viewModel: bannerItems[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddSportTargetVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SportBasicTViewCell else {
            fatalError("Issue dequeuing \(cellIdentifier)")
        }
        
        cell.selectionStyle = .none
        //let model = data[indexPath.row]
        //cell.configureCell(viewModel: model)
        cell.configureCell(viewModel: infoModels[indexPath.row])
        //cell.cellIndex = indexPath.row
        return cell
    }
}
