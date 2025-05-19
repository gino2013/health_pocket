//
//  ReminderSectionTVCell.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/5.
//

import UIKit

class ReminderSectionTVCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var cellBaseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(title: String) {
        cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        cellBaseView.layer.cornerRadius = 12
        sectionTitleLabel.text = title
    }
}
