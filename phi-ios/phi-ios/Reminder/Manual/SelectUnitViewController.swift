//
//  SelectUnitViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/22.
//

import UIKit

class SelectUnitViewController: BaseViewController,
                                UIPickerViewDelegate,
                                UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let unitArray = ["顆", "毫克(mg)", "毫升(ml)", "單位"]
    var currentSelectUnit: String = ""
    var onSaveUnit: ((_ unit: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func selectDoneAction(_ sender: UIButton) {
        dismiss(animated: false, completion: {
            if self.currentSelectUnit.isEmpty {
                self.currentSelectUnit = "顆"
            }
            self.onSaveUnit?(self.currentSelectUnit)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isScrolling() {
                pickerView.isUserInteractionEnabled = false
        } else {
                pickerView.isUserInteractionEnabled = true
        }
        
        return unitArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isUserInteractionEnabled = true
        
        let selectUnit = pickerView.selectedRow(inComponent: 0)
        let selectUnitStr: String = unitArray[selectUnit]
        currentSelectUnit = selectUnitStr
    }
}
