//
//  SportBasicTViewCell.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/18.
//

import UIKit

class SportBasicCellViewModel {
    let cellIndex: Int
    let cellSection: Int
    let iconImageName: String
    let mainTitle: String
    let subTitle: String
    let infoText: String
    var addBottomLine: Bool
    
    init(cellIndex: Int, cellSection: Int, iconImageName: String, mainTitle: String, subTitle: String, infoText: String, addBottomLine: Bool) {
        self.cellIndex = cellIndex
        self.cellSection = cellSection
        self.iconImageName = iconImageName
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.infoText = infoText
        self.addBottomLine = addBottomLine
    }
}

class SportBasicTViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBaseView: UIView!
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var cellIndex: Int = 0
    var cellSection: Int = 0
    var addBottomLine: Bool = true {
        didSet {
            lineView.isHidden = !addBottomLine
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(viewModel: SportBasicCellViewModel) {
        sportImageView.image = UIImage(named: viewModel.iconImageName)
        mainTitleLabel.text = viewModel.mainTitle
        addBottomLine = viewModel.addBottomLine
        cellIndex = viewModel.cellIndex
        cellSection = viewModel.cellSection
        
        /*
        cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        cellBaseView.layer.cornerRadius = 12
        */
    }
}
