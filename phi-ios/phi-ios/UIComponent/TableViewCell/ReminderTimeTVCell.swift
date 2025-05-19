//
//  ReminderTimeTVCell.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2025/2/19.
//

import UIKit

class ReminderTimeTVCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var cellBaseView: UIView!
    
    private let shadowView = UIView() // 負責陰影的額外視圖
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addTopLeftRightBorder(to view: UIView, color: UIColor, width: CGFloat) {
        let borderColor = color.cgColor
        
        // 上邊
        let topBorder = CALayer()
        topBorder.backgroundColor = borderColor
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: width)
        view.layer.addSublayer(topBorder)
        
        // 左邊
        let leftBorder = CALayer()
        leftBorder.backgroundColor = borderColor
        leftBorder.frame = CGRect(x: 0, y: 0, width: width, height: view.frame.height)
        view.layer.addSublayer(leftBorder)
        
        // 右邊
        let rightBorder = CALayer()
        rightBorder.backgroundColor = borderColor
        rightBorder.frame = CGRect(x: view.frame.width - width, y: 0, width: width, height: view.frame.height)
        view.layer.addSublayer(rightBorder)
    }
    
    func configureCell(title: String) {
        contentView.clipsToBounds = false
        contentView.backgroundColor = .clear // 讓 Cell 背景透明，不影響陰影
        cellBaseView.layer.masksToBounds = true // 確保圓角內的內容不溢出
        cellBaseView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        sectionTitleLabel.text = title
    }
}
