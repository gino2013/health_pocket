//
//  AddReminderTViewCell.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/8.
//

import UIKit

enum AddReminderTViewCellSelectStatus: Int {
    case noSelect
    case selected
    case disable
    case reminderSetDone
}

class AddReminderTViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBaseView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var medicineAliasLabel: UILabel!
    @IBOutlet weak var perDoseLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var takingTimeLabel: UILabel!
    
    var cellIndex: Int = 0
    var addBottomLine: Bool = true {
        didSet {
            lineView.isHidden = !addBottomLine
        }
    }
    var isSelect: AddReminderTViewCellSelectStatus = .noSelect {
        didSet {
            if isSelect == .noSelect {
                selectButton.setImage(UIImage(named: "Radio_Btn"), for: .normal)
            } else if isSelect == .selected {
                selectButton.setImage(UIImage(named: "Radio_Btn_Done"), for: .normal)
            } else if isSelect == .disable {
                selectButton.setImage(UIImage(named: "Radio_Btn_Disable"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: AddReminderCellViewModel) {
        mainTitleLabel.text = viewModel.cellInfo.medicineName
        medicineAliasLabel.text = viewModel.cellInfo.medicineAlias
        perDoseLabel.text = "\(viewModel.cellInfo.dose)\(viewModel.cellInfo.doseUnits)"
        usageLabel.text = viewModel.cellInfo.usagetimeDesc
        takingTimeLabel.text = viewModel.cellInfo.takingTime
        addBottomLine = viewModel.addBottomLine
        isSelect = viewModel.selectStatus
        
        //cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        cellBaseView.layer.cornerRadius = 12
        cellBaseView.clipsToBounds = true
        cellBaseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        cellBaseView.layer.borderWidth = 1.0
    }
}
