//
//  SelectContentVC.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/22.
//

import UIKit

class SelectContentVC: BaseViewController,
                                UIPickerViewDelegate,
                                UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerTitle: UILabel!
    
    var viewTitle: String = ""
    var itemArray: [String] = []
    var currentSelectItem: String = ""
    var onSaveItem: ((_ item: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerTitle.text = viewTitle
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func selectDoneAction(_ sender: UIButton) {
        dismiss(animated: false, completion: {
            if self.currentSelectItem.isEmpty {
                if self.itemArray.count > 0 {
                    self.currentSelectItem = self.itemArray.first ?? ""
                }
            }
            self.onSaveItem?(self.currentSelectItem)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isScrolling() {
                pickerView.isUserInteractionEnabled = false
        } else {
                pickerView.isUserInteractionEnabled = true
        }
        
        return itemArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isUserInteractionEnabled = true
        
        let selectItem = pickerView.selectedRow(inComponent: 0)
        let selectItemStr: String = itemArray[selectItem]
        currentSelectItem = selectItemStr
    }
}
