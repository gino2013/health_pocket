//
//  NormalMessageTableViewCell.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/6/25.
//

import UIKit

class NormalMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var haveReadImageView: UIImageView!
    
    var cellIndex: Int = 0
    var cellType: MessageCellType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: MessageCellViewModel) {
        if !viewModel.haveRead {
            baseView.backgroundColor = UIColor(hex: "#EBF5FB", alpha: 1.0)
            haveReadImageView.isHidden = false
        } else {
            baseView.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1.0)
            haveReadImageView.isHidden = true
        }
        
        mainTitleLabel.text = viewModel.mainTitle
        subTitleLabel.text = viewModel.subTitle
        dateTimeLabel.text = viewModel.dateTime
    }
}
