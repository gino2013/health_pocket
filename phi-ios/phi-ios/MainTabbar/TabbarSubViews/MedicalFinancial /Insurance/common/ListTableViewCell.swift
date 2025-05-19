//
//  ListTableViewCell.swift
//  phi-ios
//
//  Created by Kenneth on 2024/11/14.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var vicinityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(itemName: String?) {
        if let itemName = itemName {
            nameLabel.text = itemName
            //vicinityLabel.text = item.vicinity
        } else {
            nameLabel.text = ""
            //vicinityLabel.text = ""
        }
    }
}
