//
//  Extensions.swift
//  phi-ios
//
//  Created by Kenneth on 2024/8/26.
//

import Foundation

/// `String` 的擴展，提供了多種實用的字符串處理方法。
extension String {
    
    /// 驗證字符串是否匹配給定的正則表達式模式。
    ///
    /// - Parameter pattern: 正則表達式模式。
    /// - Returns: 如果字符串匹配模式，返回 `true`。
    func matches(pattern: String) -> Bool {
        return range(of: pattern,
                     options: String.CompareOptions.regularExpression,
                     range: nil, locale: nil) != nil
    }
    
    /// 使用 NSPredicate 驗證字符串是否符合給定的正則表達式。
    ///
    /// - Parameters:
    ///   - checkStr: 要驗證的字符串。
    ///   - regex: 正則表達式模式。
    /// - Returns: 如果字符串符合正則表達式，返回 `true`。
    func isValid(checkStr: String!, regex:String!) -> Bool {
        let predicte = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicte.evaluate(with: checkStr)
    }
    
    /// 根據最小和最大長度生成密碼正則表達式。
    ///
    /// - Parameters:
    ///   - min: 密碼的最小長度。
    ///   - max: 密碼的最大長度。
    ///   - isNewRegex: 是否使用新規則（包含至少一個符號）。
    /// - Returns: 用於驗證密碼的正則表達式。
    func getPasswordRegex(_ min: Int, _ max: Int, isNewRegex: Bool? = false) -> String {
        // Passwords will have new requirements
        // 1. English letters & numbers only
        // 2. Must include at least one symbol
        // 3. Between 6 & 20 characters

        guard min > 0, max > 0, min < max else {
            return ""
        }
        
        if let isNewRegex = isNewRegex, isNewRegex {
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,20}$"
        } else {
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),\(max)}$"
        }
    }
    
    /// 將字符串的首字母大寫，其他字母小寫。
    ///
    /// - Returns: 首字母大寫的字符串。
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    /// 根據時間戳創建日期字符串。
    ///
    /// - Parameters:
    ///   - dateFormatterString: 日期格式字符串，默認為 "dd/MM/yyyy HH:mm:ss"。
    ///   - timeStamp: Unix 時間戳。
    init(dateFormatterString: String = "dd/MM/yyyy HH:mm:ss", timeStamp: TimeInterval) {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatterString
        self = dateFormatter.string(from: date)
    }
    
    /// 驗證字符串是否僅包含英文字母和數字。
    public var isEnglishAndNumber: Bool {
        guard !self.isEmpty else { return false }
        let characterset = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._-")
        guard self.rangeOfCharacter(from: characterset.inverted) == nil else { return false }
        return true
    }
    
    /// 驗證字符串是否為有效的台灣手機號碼。
    public var isNewPhoneNumber: Bool{
        return matches(pattern: "^09[0-9]{8}$")
    }
    
    /// 驗證字符串的長度是否超過 50 個字符。
    public var isGreaterThanFifty: Bool {
        return self.count > 50
    }
    
    /// 驗證字符串是否僅包含中文或英文字母。
    public var isChineseOrEnglish: Bool {
        return matches(pattern: "^[ \\u4e00-\\u9fa5a-zA-Z]+$")
    }
    
    /// 驗證字符串是否符合英文字母或數字的密碼要求（6 到 14 個字符）。
    public var isEnglishOrNumber: Bool {
        return matches(pattern: "^(?=.*[A-Za-z])[A-Za-z\\d]{6,14}$")
    }
    
    /// 驗證字符串是否僅包含中文、英文字母或數字。
    public var isChineseOrEnglishOrNumber: Bool {
        return matches(pattern: "^[\\u4e00-\\u9fa5a-zA-Z0-9 ]+$")
    }
    
    /// 驗證字符串是否符合 6 到 20 個字符的密碼要求。
    public var is6Password: Bool {
        let regex: String = getPasswordRegex(6, 20)
        return isValid(checkStr: self, regex: regex)
    }
    
    /// 驗證字符串是否符合新規則的 6 到 20 個字符的密碼要求。
    public var isNew6Password: Bool {
        let regex: String = getPasswordRegex(6, 20, isNewRegex: true)
        return isValid(checkStr: self, regex: regex)
    }
    
    /// 將字符串轉換為貨幣格式。
    ///
    /// - Parameter locale: 地區設置，默認為當前地區。
    /// - Returns: 格式化的貨幣字符串。
    public func currency(locale: Locale = .current) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        return currencyFormatter.string(from: NSDecimalNumber(string: self))
    }
    
    /// 截取小數點後指定位數的字符串。
    ///
    /// - Parameter position: 保留的小數位數。
    /// - Returns: 截取後的字符串。
    public func afterPoint(position: Int) -> String {
        let components: Array = self.components(separatedBy: ".")
        
        if components.count == 1 {
            return self
        } else {
            guard let decimal = components.last else { return self }
            
            if position > decimal.count {
                return self + String(repeating: "0", count: (position - decimal.count))
            } else {
                return (components.first?.appendingFormat(".%@", ((decimal as NSString).substring(to: position))))!
            }
        }
    }
    
    /// 將字符串轉換為指定格式的 `Date` 物件。
    ///
    /// - Parameters:
    ///   - format: 日期格式字符串。
    ///   - locale: 地區設置標識符。
    /// - Returns: 可選的 `Date` 物件，如果轉換失敗則為 `nil`。
    public func date(withFormat format: String, locale: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: locale)
        return dateFormatter.date(from: self)
    }
    
    /// 將字符串格式化為指定的小數位數並可選地添加前綴、後綴和分隔符。
    ///
    /// - Parameters:
    ///   - places: 保留的小數位數，默認為字符串的長度。
    ///   - needPaddingEnd: 是否需要填充尾部的 0。
    ///   - prefix: 可選的前綴。
    ///   - suffix: 可選的後綴。
    ///   - usesGroupingSeparator: 可選的分組分隔符及分組大小。
    /// - Returns: 格式化後的字符串。
    public func stringFormatter(places: Int? = nil, needPaddingEnd: Bool = false, prefix: String? = nil, suffix: String? = nil, usesGroupingSeparator: (separator: String, size: Int)? = nil) -> String {
        guard let number = NumberFormatter().number(from: self) else { return self }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = places ?? self.count
        numberFormatter.minimumFractionDigits = needPaddingEnd ? (places ?? 0) : 0
        numberFormatter.roundingMode = .floor
        numberFormatter.positivePrefix = prefix
        numberFormatter.positiveSuffix = suffix
        if let usesGroupingSeparator = usesGroupingSeparator {
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.groupingSeparator = usesGroupingSeparator.separator
            numberFormatter.groupingSize = usesGroupingSeparator.size
        }
        return numberFormatter.string(from: number) ?? self
    }
    
    /// 將 JSON 格式的字符串轉換為字典。
    ///
    /// - Returns: 包含鍵值對的字典，如果轉換失敗則為 `nil`。
    public func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }
    
    /// 查找子字符串在當前字符串中的 NSRange 範圍。
    ///
    /// - Parameter searchString: 要查找的子字符串。
    /// - Returns: 可選的 NSRange 範圍，如果未找到則為 `nil`。
    public func nsrange(of searchString: String) -> NSRange? {
        guard let range = self.range(of: searchString) else { return nil }
        let nsrange = NSRange(range, in: self)
        return nsrange
    }
    
    /// 驗證字符串是否為數字。
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// 將字符串轉換為整數，如果轉換失敗則返回 0。
    var integer: Int {
        return Int(self) ?? 0
    }
    
    /// 將字符串格式的時間轉換為以秒為單位的整數。
    var secondFromString : Int {
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        let seconds = components[2].integer
        
        return Int((hours * 60 * 60) + (minutes * 60) + seconds)
    }
    
    /// 將字符串的所有字符遮罩為星號。
    var maskSensitiveInfoName: String {
        return String(repeating: "*", count: count)
    }
    
    /// 將電子郵件字符串遮罩為星號，只顯示部分內容。
    var maskSensitiveInfoEmail: String {
        let components = self.components(separatedBy: "@")
        if let account = components.first , account.count <= 3 {
            return account + "@" + components[1]
        }
        return String(repeating: "*", count: components[0].count-3) + components[0].suffix(3) + "@" + components[1]
    }
    
    /// 將字符串遮罩為星號，遮罩所有字符。
    var maskSensitiveInfo: String {
        return String(repeating: "*", count: count)
    }
    
    /// 將字符串遮罩為星號，保留第一個字符。
    var maskSensitiveInfoExceptFirst: String {
        return self.prefix(1) + String(repeating: "*", count: count-1)
    }
    
    /// 將電話號碼字符串遮罩為星號，只顯示後四位。
    var phoneMasked: String {
        if self.contains("-") {
            let prefix: String = "**-"
            return prefix + String(repeating: "*", count: Swift.max(0, count - 4 - prefix.count)) + suffix(4)
        } else {
            return String(repeating: "*", count: Swift.max(0, count - 4)) + suffix(4)
        }
    }
    
    /// 將銀行帳號字符串遮罩為星號，只顯示後三位。
    var bankAccountMasked: String {
        return String(repeating: "*", count: Swift.max(0, count - 3)) + suffix(3)
    }
    
    /// 將身份證號碼字符串遮罩為星號，只顯示後六位。
    var nationalIDMasked: String {
        return String(repeating: "*", count: Swift.max(0, count - 6)) + suffix(6)
    }
    
    /// 驗證姓名字符串是否符合要求。
    ///
    /// - Returns: 元組，包含提示信息和驗證結果。
    var isNameAvailable: (String, Bool) {
        guard !isEmpty else { return ("请输入全名", false) }
        guard !contains(" ") else { return ("格式不正确", false) }
        guard count < 16 else { return ("姓名限输入15个字", false) }
        guard isValid(checkStr: self, regex: "^[\\u4e00-\\u9fa5]+$") else {
            return ("格式不正确", false)
        }
        guard self.count > 1 else { return ("请输入全名", false) }
        
        return ("", true)
    }
    
    /// 驗證銀行帳號是否符合要求。
    var isBankAccountAvailable: Bool {
        return count >= 16 && count <= 19
    }
    
    /// 驗證銀行名稱是否符合要求（僅中文字符）。
    var isBankNameAvailable: Bool {
        return isValid(checkStr: self, regex: "^[\\u4e00-\\u9fa5]+$")
    }
    
    /// 驗證身份證號碼是否符合要求。
    var checkIsIdentityCard: Bool {
        return isValid(checkStr: self, regex: "^\\d{17}(\\d|X|x)$")
        
        /*
        if count <= 0 {
            return false
        }
        //判斷是否是18位，末尾是否是x
        let regex2: String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let identityCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex2)
        if !identityCardPredicate.evaluate(with: self) {
            return false
        }
        //判斷生日是否合法
        let range = NSRange(location: 6, length: 8)
        let datestr: String = (self as NSString).substring(with: range)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if formatter.date(from: datestr) == nil {
            return false
        }
        //判斷校驗位
        if  count == 18 {
            let idCardWi: [String] = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"]
            //將前17位加權因子保存在數組裏
            let idCardY: [String] = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
            //這是除以11後，可能產生的11位餘數、驗證碼，也保存成數組
            var idCardWiSum: Int = 0
            //用來保存前17位各自乖以加權因子後的總和
            for i in 0..<17 {
                idCardWiSum += Int((self as NSString).substring(with: NSRange(location: i, length: 1)))! * Int(idCardWi[i])!
            }
            let idCardMod: Int = idCardWiSum % 11
            
            let idCardLast: String = String(self.suffix(1))//截取最後一個字符串
            //得到最後一位身份證號碼
            //如果等於2，則說明校驗碼是10，身份證號碼最後一位應該是X
            if idCardMod == 2 {
                if idCardLast == "X" || idCardLast == "x" {
                    return true
                } else {
                    return false
                }
            } else {
                //用計算出的驗證碼與最後一位身份證號碼匹配，如果一致，說明通過，否則是無效的身份證號碼
                if (idCardLast as NSString).integerValue == Int(idCardY[idCardMod]) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
        */
    }
}

extension Double {
    var cleanString: String {
        return self.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)  // 沒有小數
            : String(format: "%.1f", self)  // 有小數，保留一位
    }
}
