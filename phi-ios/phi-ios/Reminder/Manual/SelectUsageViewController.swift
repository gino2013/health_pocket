//
//  SelectUsageViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/22.
//

import UIKit

class SelectUsageViewController: BaseViewController,
                                 UIPickerViewDelegate,
                                 UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var currentSelectUsage: String = ""
    var currentSelectUsageTime: Int = 1
    var onSaveUsage: ((_ usage: String, _ useageTime: Int) -> ())?
    let usageArray = ["每日一次",
                      "每日二次",
                      "每日三次",
                      "每日四次",
                      "每週一次",
                      "每週二次",
                      "每週三次",
                      "其它時段"]
    let usageTimeArray = [1,
                          2,
                          3,
                          4,
                          1,
                          2,
                          3,
                          -1]
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
            if self.currentSelectUsage.isEmpty {
                self.currentSelectUsage = "每日一次"
            }
            self.onSaveUsage?(self.currentSelectUsage, self.currentSelectUsageTime)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isScrolling() {
                pickerView.isUserInteractionEnabled = false
        } else {
                pickerView.isUserInteractionEnabled = true
        }
        
        return usageArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isUserInteractionEnabled = true
        
        let selectUsage = pickerView.selectedRow(inComponent: 0)
        let selectUsageStr: String = usageArray[selectUsage]
        currentSelectUsage = selectUsageStr
        currentSelectUsageTime = usageTimeArray[selectUsage]
        
        // print("selectGenderStr: \(selectGenderStr)")
    }
}
