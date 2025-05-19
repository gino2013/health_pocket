//
//  LocalizableKeys.swift
//  phi-ios
//
//  Created by Kenneth on 2024/10/15.
//

import Foundation

// 擴展翻譯
/*
 
當您需要新增更多的翻譯時，只需要在 LocalizableKeys 枚舉中新增對應的鍵值，
並更新 Localizable.strings 文件。
 
例如：

(1)更新 LocalizableKeys.swift：
case newFeatureDescription = "new_feature_description"

(2)更新 Localizable.strings (繁體中文)：
"new_feature_description" = "這是新的功能介紹";

(3)更新 Localizable.strings (英文)：
"new_feature_description" = "This is the description of the new feature";
 
(4)在ViewController中使用：
 // 設置本地化的文本
 greetingLabel.text = LocalizableKeys.hello.localized
 logoutButton.setTitle(LocalizableKeys.homeLogout.localized, for: .normal)
 themeLabel.text = LocalizableKeys.settingsThemeChange.localized
 
*/

// 定義本地化鍵的枚舉
enum LocalizableKeys: String {
    case hello = "hello"
    case goodbye = "goodbye"
    case homeWelcome = "home_welcome"
    case homeLogout = "home_logout_button"
    case settingsLanguageChange = "settings_language_change"
    case settingsThemeChange = "settings_theme_change"
    
    // phi login view
    case loginViewTitle = "login_view_title"

    // 本地化計算屬性
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
