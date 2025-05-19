//
//  AuthHospitailTableViewCell.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/18.
//

import UIKit

class AuthHospitailTableViewCell: UITableViewCell {

    @IBOutlet weak var hospitalLabel: UILabel!
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
    
    func configureCell(title: String, buttonTitle: String) {
        cellBaseView.addShadow(color: UIColor(red: 39/255, green: 44/255, blue: 46/255, alpha: 0.05), opacity: 1, radius: 12, offset: CGSize(width: 0, height: 2))
        cellBaseView.layer.cornerRadius = 12
        hospitalLabel.text = title
    }
    
    /*
    func configureParameters(forLabel label: (fontName: String, fontSize: CGFloat, color: UIColor),
                             forButton button: (fontName: String, fontSize: CGFloat, color: UIColor)) {
        
        hospitalItem.itemLabel.font = UIFont(name: label.fontName, size: label.fontSize)
        hospitalItem.itemLabel.textColor = label.color
        
        hospitalItem.nextButton.titleLabel?.font = UIFont(name: button.fontName, size: button.fontSize)
        hospitalItem.nextButton.setTitleColor(button.color, for: .normal)
    }
     */
}
