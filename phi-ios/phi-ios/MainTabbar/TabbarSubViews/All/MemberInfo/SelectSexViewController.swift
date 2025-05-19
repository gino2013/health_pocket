//
//  SelectSexViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/4/3.
//

import UIKit

class SelectSexViewController: BaseViewController,
                               UIPickerViewDelegate,
                               UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let genderArray = ["女性", "男性"]
    var currentSelectSex: String = ""
    var onSaveGender: ((_ gender: String) -> ())?
    
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
            if self.currentSelectSex.isEmpty {
                self.currentSelectSex = "女性"
            }
            self.onSaveGender?(self.currentSelectSex)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isScrolling() {
                pickerView.isUserInteractionEnabled = false
        } else {
                pickerView.isUserInteractionEnabled = true
        }
        
        return genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isUserInteractionEnabled = true
        
        let selectGender = pickerView.selectedRow(inComponent: 0)
        let selectGenderStr: String = genderArray[selectGender]
        currentSelectSex = selectGenderStr
        // print("selectGenderStr: \(selectGenderStr)")
    }
}

// 判斷捲動
extension UIView {
    func isScrolling () -> Bool {
        if let scrollView = self as? UIScrollView {
            if (scrollView.isDragging || scrollView.isDecelerating) {
                return true
            }
        }
        for subview in self.subviews {
            if subview.isScrolling() {
                return true
            }
        }
        return false
    }
}
