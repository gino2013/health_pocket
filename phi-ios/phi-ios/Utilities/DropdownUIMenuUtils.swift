//
//  DropdownUIMenuUtils.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/10/17.
//

import UIKit

enum DemoItemDropdownOption: String, CaseIterable {
    case signPDF = "PDF簽名"
    case sportTarget = "運動目標"
    case sportInfo = "運動資訊"
    case speechDemo = "Speech Demo"
    case googleAIDemo = "Google AI"
    case resetReminderSetting = "重置提醒設定"
    case SwiftUI = "SwiftUI"
    
    var title: String {
        switch self {
        case .signPDF:
            return "PDF簽名"
        case .sportTarget:
            return "運動目標"
        case .sportInfo:
            return "運動資訊"
        case .speechDemo:
            return "Speech Demo"
        case .googleAIDemo:
            return "Google AI"
        case.resetReminderSetting:
            return "重置提醒設定"
        case .SwiftUI:
            return "SwiftUI Demo"
        }
    }
}

enum SportFrequencyDropdownOption: String, CaseIterable {
    case noRepeat = "不重複"
    case everyDay = "每天"
    case everyWeek = "每週"
    case everyTwoWeeks = "每兩週"
    
    // 計算屬性，根據枚舉的 case 返回顯示的標題
    var title: String {
        switch self {
        case .noRepeat:
            return "不重複"
        case .everyDay:
            return "每天"
        case .everyWeek:
            return "每週"
        case .everyTwoWeeks:
            return "每兩週"
        }
    }
}

class DropdownUIMenuUtils {
    
    // 創建並返回 UIMenu，供其他 ViewController 使用
    static func createDropdownMenu(selectedOptionKey: String, selectionHandler: @escaping (DemoItemDropdownOption) -> Void) -> UIMenu {
        // 讀取用戶上次保存的選項
        let savedOptionRawValue = UserDefaults.standard.string(forKey: selectedOptionKey) ?? DemoItemDropdownOption.signPDF.rawValue
        let savedOption = DemoItemDropdownOption(rawValue: savedOptionRawValue) ?? .signPDF
        
        // 使用 map 生成每個 UIAction
        let actions = DemoItemDropdownOption.allCases.map { option in
            UIAction(title: option.title, state: savedOption == option ? .on : .off) { _ in
                // 保存選擇，並調用回調函數
                saveSelection(option: option, key: selectedOptionKey)
                selectionHandler(option)
            }
        }
        
        // 返回生成的 UIMenu
        return UIMenu(title: "", children: actions)
    }
    
    // 保存選項到 UserDefaults
    private static func saveSelection(option: DemoItemDropdownOption, key: String) {
        UserDefaults.standard.set(option.rawValue, forKey: key)
        print("已保存選擇 \(option.title) 到 key: \(key)")
    }
}
