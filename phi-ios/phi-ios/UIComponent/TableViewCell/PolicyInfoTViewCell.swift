//
//  PolicyInfoTViewCell.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/24.
//

import UIKit

protocol PolicyInfoTViewCellDelegate: AnyObject {
    func didTapDeleteButtonAtCellIndex(index: Int)
    func didTapDeleteButtonAtCellUUID(uuid: String)
}

class PolicyInfoTViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBaseView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var contractDateLabel: UILabel!
    
    var cellIndex: String = ""
    weak var delegate: PolicyInfoTViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(viewModel: PolicyInfoCellViewModel) {
        companyNameLabel.text = viewModel.cellInfo.vpzqsmuName
        productNameLabel.text = viewModel.cellInfo.productName
        unitLabel.text = viewModel.cellInfo.unit
        contractDateLabel.text = viewModel.cellInfo.contractDate
        
        cellBaseView.layer.cornerRadius = 12
        cellBaseView.clipsToBounds = true
        cellBaseView.layer.borderColor = UIColor(hex: "#F0F0F0", alpha: 1)?.cgColor
        cellBaseView.layer.borderWidth = 1.0
        
        cellIndex = viewModel.cellId
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        //delete?.didTapDeleteButtonAtCellIndex(index: cellIndex)
        delegate?.didTapDeleteButtonAtCellUUID(uuid: cellIndex)
    }
}
