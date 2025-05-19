//
//  PharmacyInfoTViewCell.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/22.
//

import UIKit

class PharmacyInfoTViewCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var cellIndex: Int = 0
    var isPartnership: Bool = true {
        didSet {
            if isPartnership {
                middleView.isHidden = false
            } else {
                middleView.isHidden = true
            }
        }
    }
    var isSelectedCell: Bool = false {
        didSet {
            if isSelectedCell {
                // 添加圓角和邊框到 stackView
                stackView.layer.cornerRadius = 12.0
                stackView.layer.borderWidth = 2.0
                stackView.layer.borderColor = UIColor(hex: "#76BBE7", alpha: 1.0)?.cgColor
                stackView.layer.masksToBounds = true
            } else {
                // 添加圓角和邊框到 stackView
                stackView.layer.cornerRadius = 12.0
                stackView.layer.borderWidth = 0
                stackView.layer.borderColor = UIColor.clear.cgColor
                stackView.layer.masksToBounds = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: PharmacyCellViewModel) {
        hospitalLabel.text = viewModel.hospitalName
        firstButton.setTitle(viewModel.isReserve, for: .normal)
        
        if viewModel.receiveMedicineTimes.isEmpty {
            secondButton.isHidden = true
        } else {
            secondButton.setTitle(viewModel.receiveMedicineTimes, for: .normal)
        }
        distanceLabel.text = viewModel.distance
        addressLabel.text = viewModel.address
        isPartnership = viewModel.isPartner
        isSelectedCell = viewModel.isSelectCell
        
        topView.roundCACorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        //topView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        
        topView.addShadow(
            topColor: UIColor.black, topOpacity: 0.9, topRadius: 16, topOffset: CGSize(width: 0, height: -4),
            bottomOpacity: 0, // 不添加底部陰影
            leftColor: UIColor.black, leftOpacity: 0.9, leftRadius: 16, leftOffset: CGSize(width: -4, height: 0),
            rightColor: UIColor.black, rightOpacity: 0.9, rightRadius: 16, rightOffset: CGSize(width: 4, height: 0)
        )
        
        middleView.addShadow(
            topOpacity: 0,
            bottomOpacity: 0,
            leftColor: UIColor.black, leftOpacity: 0.9, leftRadius: 16, leftOffset: CGSize(width: -4, height: 0),
            rightColor: UIColor.black, rightOpacity: 0.9, rightRadius: 16, rightOffset: CGSize(width: 4, height: 0)
        )
        
        bottomView.roundCACorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 12)
        //bottomView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        topView.addShadow(
            topOpacity: 0, // 不添加頂部陰影
            bottomColor: UIColor.black, bottomOpacity: 0.9, bottomRadius: 16, bottomOffset: CGSize(width: 0, height: 4),
            leftColor: UIColor.black, leftOpacity: 0.9, leftRadius: 16, leftOffset: CGSize(width: -4, height: 0),
            rightColor: UIColor.black, rightOpacity: 0.9, rightRadius: 16, rightOffset: CGSize(width: 4, height: 0)
        )
    }
}
