//
//  MedicalHistoryTViewCell.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/13.
//

import UIKit

protocol MedicalHistoryTViewCellDelegate: AnyObject {
    func didTapLeftButtonAtCellIndex(_ cell: MedicalHistoryTViewCell, index: Int)
    func didTapRightButtonAtCellIndex(_ cell: MedicalHistoryTViewCell, index: Int)
}

class MedicalHistoryTViewCell: UITableViewCell {
    // organizationName
    @IBOutlet weak var hospitalLabel: UILabel!
    // medicalType
    @IBOutlet weak var medicalButton: UIButton!
    // nthReceiveTime
    @IBOutlet weak var nthReceiveTimeButton: UIButton!
    // opdDate
    @IBOutlet weak var opdDateLabel: UILabel!
    // physicianName
    @IBOutlet weak var physicianNameLabel: UILabel!
    // icdName
    @IBOutlet weak var icdNameLabel: UILabel!
    // startDate-endDate
    @IBOutlet weak var rangeLabel: UILabel!
    // receiveStatusDesc
    @IBOutlet weak var receiveStatusLabel: UILabel!
    // ======
    @IBOutlet weak var foldButton: UIButton!
    @IBOutlet weak var topBaseView: UIView!
    @IBOutlet weak var topSecondBaseView: UIView!
    @IBOutlet weak var bottomBaseView: UIView!
    @IBOutlet weak var leftButton: UICustomButton!
    @IBOutlet weak var qrCodeButton: UICustomButton!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var delegate: MedicalHistoryTViewCellDelegate?
    var cellIndex: Int = 0
    var isExpand: Bool = true {
        didSet {
            if isExpand {
                foldButton.setImage(UIImage(named: "fold"), for: .normal)
            } else {
                foldButton.setImage(UIImage(named: "unfold"), for: .normal)
            }
        }
    }
    var isEnableLeftButton: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topBaseView.layer.cornerRadius = 12
        topBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        topSecondBaseView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        topSecondBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        bottomBaseView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        bottomBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        medicalButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        medicalButton.layer.borderWidth = 1.0
        nthReceiveTimeButton.layer.borderColor = UIColor(hex: "#EDB935", alpha: 1)!.cgColor
        nthReceiveTimeButton.layer.borderWidth = 1.0
        leftButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
        leftButton.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: MedHistoryTViewCellViewModel) {
        hospitalLabel.text = viewModel.hospitalName
        medicalButton.setTitle(viewModel.type, for: .normal)
        nthReceiveTimeButton.setTitle(viewModel.nthReceiveTime, for: .normal)
        opdDateLabel.text = viewModel.date
        physicianNameLabel.text = viewModel.name
        icdNameLabel.text = viewModel.diseaseType
        rangeLabel.text = viewModel.dateRange
        receiveStatusLabel.text = viewModel.rcvStatusDesc
        isExpand = viewModel.expanded
        
        // 領藥狀態: 0-已領藥、1-已預約、2-可領藥、3-現場領藥中
        if viewModel.rcvStatus == "1" ||
            viewModel.rcvStatus == "0" ||
            viewModel.rcvStatus == "3" {
            isEnableLeftButton = false
            leftButton.layer.borderColor = UIColor(hex: "#C7C7C7", alpha: 1)!.cgColor
            leftButton.layer.borderWidth = 1.0
            leftButton.setTitleColor(UIColor(hex: "#C7C7C7", alpha: 1), for: .normal)
        } else {
            isEnableLeftButton = true
            leftButton.layer.borderColor = UIColor(hex: "#3399DB", alpha: 1)!.cgColor
            leftButton.layer.borderWidth = 1.0
            leftButton.setTitleColor(UIColor(hex: "#3399DB", alpha: 1), for: .normal)
        }
        
        if isExpand {
            topSecondBaseView.isHidden = false
        } else {
            topSecondBaseView.isHidden = true
        }
        
        if viewModel.isPrescriptionEnded {
            leftButton.isHidden = true
        } else {
            leftButton.isHidden = false
        }
    }
    
    @IBAction func clickLeftBtnAction(_ sender: UIButton) {
        // 領藥狀態: 0-已領藥、1-已預約、2-可領藥
        if isEnableLeftButton {
            delegate?.didTapLeftButtonAtCellIndex(self, index: cellIndex)
        }
    }
    
    @IBAction func clickRightBtnAction(_ sender: UIButton) {
        delegate?.didTapRightButtonAtCellIndex(self, index: cellIndex)
    }
    
    /*
    @IBAction func clickFoldBtnAction(_ sender: UIButton) {
        isExpand = !isExpand
    }
     */
}
