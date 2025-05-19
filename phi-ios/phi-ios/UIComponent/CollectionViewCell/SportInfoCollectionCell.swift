//
//  SportInfoCollectionCell.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/21.
//

import UIKit

class SportInfoCellViewModel {
    let cellIndex: Int
    let cellSection: Int
    let iconImageName: String
    let mainTitle: String
    let subTitle: String
    var isCustomized: Bool
    
    init(cellIndex: Int, cellSection: Int, iconImageName: String, mainTitle: String, subTitle: String, isCustomized: Bool) {
        self.cellIndex = cellIndex
        self.cellSection = cellSection
        self.iconImageName = iconImageName
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.isCustomized = isCustomized
    }
}

class SportInfoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var basicButton: UIButton!
    @IBOutlet weak var customizedButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var viewInfoButton: UICustomButton!
    @IBOutlet weak var applyButton: UICustomButton!
    
    var cellIndex: Int = 0
    var cellSection: Int = 0
    private let dybaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 添加 dybaseView 到 contentView
        contentView.addSubview(dybaseView)
        
        // 設置 dybaseView 的邊距
        NSLayoutConstraint.activate([
            dybaseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            dybaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            dybaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            dybaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
        
        // 設置 dybaseView 的陰影和圓角
        configureBaseViewAppearance()
        
        viewInfoButton.backgroundColor = UIColor.white
        viewInfoButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        viewInfoButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        viewInfoButton.layer.borderWidth = 1.0
    }

    func configureCell(viewModel: SportInfoCellViewModel) {
        cellIndex = viewModel.cellIndex
        cellSection = viewModel.cellSection
        mainImageView.image = UIImage(named: viewModel.iconImageName)
        mainTitleLabel.text = viewModel.mainTitle
        subTitleLabel.text = viewModel.subTitle
        basicButton.isHidden = viewModel.isCustomized
        customizedButton.isHidden = !viewModel.isCustomized
    }
    
    private func configureBaseViewAppearance() {
        //let veryDarkShadowColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0) // 接近純黑的顏色
        //dybaseView.addShadow(color: veryDarkShadowColor, opacity: 0.5, radius: 10, offset: CGSize(width: 0, height: 3))
        //dybaseView.layer.cornerRadius = 8
        
        //dybaseView.layer.borderColor = UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05).cgColor
        dybaseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1.0)?.cgColor
        dybaseView.layer.borderWidth = 1.0  // 邊框寬度設置
        dybaseView.layer.cornerRadius = 8   // 邊框圓角
    }
    
    private func configureBaseViewAppearanceTemp() {
        // 設置陰影
        dybaseView.layer.shadowColor = UIColor.black.cgColor    // 陰影顏色
        dybaseView.layer.shadowOpacity = 0.3                    // 陰影透明度
        dybaseView.layer.shadowRadius = 8                       // 陰影模糊半徑
        dybaseView.layer.shadowOffset = CGSize(width: 0, height: 4) // 陰影偏移

        // 設置邊框
        dybaseView.layer.borderColor = UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05).cgColor
        dybaseView.layer.borderWidth = 1.0  // 邊框寬度
        dybaseView.layer.cornerRadius = 8   // 設置圓角
        
        // 禁用裁剪邊界，這樣陰影不會被剪掉
        dybaseView.layer.masksToBounds = false
    }
}
