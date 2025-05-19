//
//  ValidateUtils.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import Foundation

class ValidateUtils {
    class func checkIfNumber(src: String) -> Bool {
        // 檢查輸入的是否為數字
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let stringCharacterSet = CharacterSet(charactersIn: src)
        if !allowedCharacterSet.isSuperset(of: stringCharacterSet) {
            return false
        }
        return true
    }
    
    class func isValidatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^09\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: phoneNumber)
    }
    
    // MARK: Utils
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /*
     func isValidEmail(email: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
     let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
     return emailPredicate.evaluate(with: email)
     }
     */
    
    class func isValidName(_ name: String) -> Bool {
        /*
        let regex = try! NSRegularExpression(pattern: "^[\\u4e00-\\u9fa5]{1,30}$", options: [])
        let matches = regex.matches(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count))
        return !matches.isEmpty
        */
        
        let nameRegEx = "^[\\u4e00-\\u9fa5]{1,30}$"
        
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }

    
    class func isPasswordValid(password: String, name: String) -> Bool {
        let lowercasePassword = password.lowercased()
        let lowercaseName = name.lowercased()
        
        // Check if the password contains the name
        if lowercasePassword.contains(lowercaseName) {
            return false
        }
        
        // Additional password validation checks can be added here
        // For example, you can check for minimum length, required characters, etc.
        
        // If all checks pass, the password is considered valid
        return true
    }
    
    class func validatePassword(_ password: String) -> Bool {
        //let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,12}$"
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,12}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    class func isValidateIDNumberEnu(idNumber: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", "[A-Z][1,2][0-9]{8}")
        guard pred.evaluate(with: idNumber) else { return false }
        
        let uppercasedSource = idNumber.uppercased()
        let cityAlphabets: [String: Int] = [
            "A": 10, "B": 11, "C": 12, "D": 13, "E": 14,
            "F": 15, "G": 16, "H": 17, "J": 18, "K": 19,
            "L": 20, "M": 21, "N": 22, "P": 23, "Q": 24,
            "R": 25, "S": 26, "T": 27, "U": 28, "V": 29,
            "X": 30, "Y": 31, "W": 32, "Z": 33, "I": 34,
            "O": 35
        ]
        
        guard let key = uppercasedSource.first, let cityNumber = cityAlphabets[String(key)] else { return false }
        
        var ints: [Int] = []
        ints.append(cityNumber % 10)
        ints.append(contentsOf: uppercasedSource.compactMap { Int(String($0)) })
        
        guard let last = ints.last else { return false }
        let initialNumber = cityNumber / 10 + last
        let total = ints.enumerated().reduce(initialNumber, { sum, next in
            return sum + next.element * (9 - next.offset)
        })
        
        return total % 10 == 0
    }
    
    class func validateBirthday(_ birthdayString: String, isInsurance: Bool = false) -> (Bool, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayString) else {
            return (false, "出生日期輸入有誤")
        }
        
        let calendar = Calendar.current
        
        // 檢查輸入日期是否大於昨天
        /*
         if birthdayDate > calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date() {
         return false
         }
         */
        
        // 檢查輸入日期是否大於今天
        if birthdayDate > Date() {
            return (false, "請輸入今天以前的日期")
        }
        
        let components = calendar.dateComponents([.year, .month, .day], from: birthdayDate)
        
        guard let year = components.year, let month = components.month, let day = components.day else {
            // 無法獲取年月日資訊
            return (false, "出生日期輸入有誤")
        }
        
        // 18-105歲之間
        guard let age = calendar.dateComponents([.year], from: birthdayDate, to: Date()).year, (18...105).contains(age) else {
            if isInsurance {
                return (false, "出生日期輸入有誤")
            }
            return (false, "可註冊帳戶年齡介於18-105歲之間")
        }
        
        // 檢查日期
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return ((1...31).contains(day), "出生日期輸入有誤")
        case 4, 6, 9, 11:
            return ((1...30).contains(day), "出生日期輸入有誤")
        case 2:
            // 檢查閏年
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
            if isLeapYear {
                return ((1...29).contains(day), "出生日期輸入有誤")
            } else {
                return ((1...28).contains(day), "出生日期輸入有誤")
            }
        default:
            return (false, "出生日期輸入有誤")
        }
    }
}
