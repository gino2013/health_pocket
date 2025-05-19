//
//  SmallReminderTViewCell.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/8/23.
//

import UIKit

class SmallReminderTViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBaseView: UIView!
    @IBOutlet weak var capsuleImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var smallLineView: UIView!
    @IBOutlet weak var takenDateTimeLabel: UILabel!
    
    var cellIndex: Int = 0
    var cellSection: Int = 0
    var addBottomLine: Bool = true {
        didSet {
            //lineView.isHidden = !addBottomLine
            lineView.isHidden = true
        }
    }
    weak var delegate: ReminderTViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //infoButton.layer.borderColor = UIColor(hex: "#EDB935", alpha: 1)!.cgColor
        //infoButton.layer.borderWidth = 1.0
        
        smallLineView.isHidden = true
        takenDateTimeLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: ReminderCellViewModel) {
        capsuleImageView.image = UIImage(named: viewModel.iconImageName)
        mainTitleLabel.text = viewModel.mainTitle
        infoButton.setTitle(viewModel.infoText, for: .normal)
        addBottomLine = viewModel.addBottomLine
        cellIndex = viewModel.cellIndex
        cellSection = viewModel.cellSection
        
        cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        cellBaseView.layer.cornerRadius = 12
    }
    
    func configureCell(viewModelExt: ReminderCellViewModelExt) {
        capsuleImageView.image = UIImage(named: viewModelExt.iconImageName)
        mainTitleLabel.text = viewModelExt.reminderInfo.title
        infoButton.setTitle(viewModelExt.reminderInfo.tags[0], for: .normal)
        addBottomLine = viewModelExt.addBottomLine
        cellIndex = viewModelExt.cellIndex
        cellSection = viewModelExt.cellSection
        
        if viewModelExt.reminderInfo.isChecked {
            //smallLineView.isHidden = false
            takenDateTimeLabel.isHidden = false
            // takenDateTimeLabel.text = String(viewModelExt.reminderInfo.checkTime.prefix(16))
            takenDateTimeLabel.text = String(viewModelExt.reminderInfo.checkTime.dropFirst(5).prefix(11))
            takenDateTimeLabel.textColor = UIColor(hex: "#246D9B", alpha: 1.0)
        } else {
            if viewModelExt.iconImageName == "Pill_None" {
                //smallLineView.isHidden = false
                takenDateTimeLabel.isHidden = false
                takenDateTimeLabel.text = "逾期未服用!"
                takenDateTimeLabel.textColor = UIColor(hex: "#E13F39", alpha: 1.0)
            } else {
                smallLineView.isHidden = true
                takenDateTimeLabel.isHidden = true
            }
        }
        
        //cellBaseView.layer.cornerRadius = 12
        
        if !addBottomLine {
            cellBaseView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
            cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        } else {
            // 重置其他 Cell 的圓角
            cellBaseView.layer.cornerRadius = 0
            cellBaseView.layer.maskedCorners = []
            cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        }
    }
    
    @IBAction func clickMoreAction(_ sender: UIButton) {
        delegate?.didTapMoreButtonAtCellIndex(index: cellIndex, section: cellSection)
    }
}
