//
//  SelectTakingTimeVC.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/22.
//

import UIKit

class SelectTakingTimeVC: BaseViewController,
                          UIPickerViewDelegate,
                          UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
   
    let takingTimeArray = ["飯前", "飯後", "睡前", "飯前、睡前", "飯後、睡前", "其它時間"]
    var currentSelectTakingTime: String = ""
    var onSaveTakingTime: ((_ takingTime: String) -> ())?
    
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
            if self.currentSelectTakingTime.isEmpty {
                self.currentSelectTakingTime = "飯後"
            }
            self.onSaveTakingTime?(self.currentSelectTakingTime)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return takingTimeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isScrolling() {
            pickerView.isUserInteractionEnabled = false
        } else {
            pickerView.isUserInteractionEnabled = true
        }
        
        return takingTimeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isUserInteractionEnabled = true
        
        let selectTakingTime = pickerView.selectedRow(inComponent: 0)
        let selectTakingTimeStr: String = takingTimeArray[selectTakingTime]
        currentSelectTakingTime = selectTakingTimeStr
    }
}
