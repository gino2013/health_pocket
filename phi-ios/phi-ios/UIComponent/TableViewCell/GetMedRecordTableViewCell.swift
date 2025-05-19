//
//  GetMedRecordTableViewCell.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/5/21.
//

import UIKit

class GetMedRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cellBaseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func button(_ sender: UIButton) {
        // delegate?.buttonTap(sender, self)
    }
    
    func updateUIviaStatus(status: String) {
        if status == "尚未開始" {
            statusButton.backgroundColor = UIColor(hex: "#EFF0F1", alpha: 1)
            statusButton.setTitleColor(UIColor(hex: "#484848", alpha: 1), for: .normal)
            statusButton.layer.borderColor = UIColor(hex: "#7E868B", alpha: 1)!.cgColor
            statusButton.layer.borderWidth = 1.0
        } else {
            statusButton.backgroundColor = UIColor(hex: "#FDF8EB", alpha: 1)
            statusButton.setTitleColor(UIColor(hex: "#A88326", alpha: 1), for: .normal)
            statusButton.layer.borderColor = UIColor(hex: "#EDB935", alpha: 1)!.cgColor
            statusButton.layer.borderWidth = 1.0
        }
    }
    
    func configureCell(title: String, status: String, date: String) {
        cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        cellBaseView.layer.cornerRadius = 12
        
        titleLabel.text = title
        statusButton.setTitle(status, for: .normal)
        dateLabel.text = date
        updateUIviaStatus(status: status)
        
        if date == "----/--/--" {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
    }
}
