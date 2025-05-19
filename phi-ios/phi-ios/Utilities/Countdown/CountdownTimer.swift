//
//  Countdown.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/3/13.
//

import UIKit

/// `CountdownTimerDelegate` 協議定義了一組回調方法，用於接收倒計時計時器的更新和完成事件。
protocol CountdownTimerDelegate: AnyObject {
    
    /// 當倒計時結束時調用此方法。
    ///
    /// - Parameter isVerifySuccess: 表示倒計時是否成功驗證。若為 `nil` 表示未驗證。
    func countdownTimerFinish(isVerifySuccess: Bool?)
    
    /// 當倒計時有更新時調用此方法，以時間的格式傳遞。
    ///
    /// - Parameter time: 包含小時、分鐘和秒的元組（均為字串格式）。
    func countdownTime(time: (hours: String, minutes: String, seconds: String))
    
    /// 當倒計時有更新時調用此方法，以個別數字的格式傳遞。
    ///
    /// - Parameters:
    ///   - hours: 小時部分，分別為兩個字元的元組 (左邊字元, 右邊字元)。
    ///   - minutes: 分鐘部分，分別為兩個字元的元組 (左邊字元, 右邊字元)。
    ///   - seconds: 秒部分，分別為兩個字元的元組 (左邊字元, 右邊字元)。
    func countdownTime(hours: (String?, String?), minutes: (String?, String?), seconds: (String?, String?))
}

/// `CountdownTimerable` 協議定義了計時器的基本操作方法。
protocol CountdownTimerable {
    
    /// 開始倒計時。
    func start()
    
    /// 當倒計時結束時調用此方法。
    ///
    /// - Parameter isVerifySuccess: 表示倒計時是否成功驗證。若為 `nil` 表示未驗證。
    func isFinish(isVerifySuccess: Bool?)
    
    /// 強制結束倒計時。
    func end()
}

/// `CountdownTimer` 類別實現了一個可配置的倒計時器，並透過委派模式將結果傳遞給 `CountdownTimerDelegate`。
class CountdownTimer: CountdownTimerable {
    
    /// 倒計時的委派，用於接收計時器事件。
    weak var delegate: CountdownTimerDelegate?
    
    /// 計時器物件，用於控制倒計時過程。
    lazy fileprivate var timer: Timer = {
        return Timer()
    }()
    
    /// 總秒數，表示倒計時的起始值。
    fileprivate var totalSeconds: Int
    
    /// 當前剩餘秒數。
    fileprivate var countdownSeconds: Int
    
    /// 儲存小時數字的元組 (左字元, 右字元)。
    var hoursTuple: (String?, String?)!
    
    /// 儲存分鐘數字的元組 (左字元, 右字元)。
    var minutesTuple: (String?, String?)!
    
    /// 儲存秒數字的元組 (左字元, 右字元)。
    var secondsTuple: (String?, String?)!
    
    /// 初始化倒計時器。
    ///
    /// - Parameters:
    ///   - hours: 初始小時數。
    ///   - minutes: 初始分鐘數。
    ///   - seconds: 初始秒數。
    init(hours: Int, minutes: Int, seconds: Int) {
        totalSeconds = (hours * 60 * 60) + (minutes * 60) + seconds
        countdownSeconds = totalSeconds
    }
}

extension CountdownTimer {
    
    /// 開始倒計時並通知委派目前的時間狀態。
    func start() {
        timer.invalidate()
        
        // 生成倒計時的時間元組
        let tuple = countdownTimeTuple(seconds: countdownSeconds)
        
        // 通知委派時間更新
        delegate?.countdownTime(time: tuple)
        
        // 更新並通知每個數字部分的變化
        hoursTuple = (tuple.hours.first?.string, tuple.hours.last?.string)
        minutesTuple = (tuple.minutes.first?.string, tuple.minutes.last?.string)
        secondsTuple = (tuple.seconds.first?.string, tuple.seconds.last?.string)
        delegate?.countdownTime(hours: hoursTuple, minutes: minutesTuple, seconds: secondsTuple)
        
        // 開始每秒的倒計時任務
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerScheduled), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    /// 結束倒計時並通知委派倒計時已完成。
    ///
    /// - Parameter isVerifySuccess: 表示倒計時是否成功驗證。
    func isFinish(isVerifySuccess: Bool? = false) {
        timer.invalidate()
        delegate?.countdownTimerFinish(isVerifySuccess: isVerifySuccess)
    }
    
    /// 強制結束倒計時。
    func end() {
        timer.invalidate()
    }
    
    /// 每秒調用此方法來更新倒計時。
    @objc fileprivate func timerScheduled() {
        if countdownSeconds <= 0 {
            timer.invalidate()
            isFinish(isVerifySuccess: true)
        } else {
            countdownSeconds -= 1
            
            let tuple = countdownTimeTuple(seconds: countdownSeconds)
            
            // 通知委派時間更新
            delegate?.countdownTime(time: tuple)
            
            // 檢查並更新小時部分的變化
            let leftHours = chechTimerTupleChange(new: tuple.hours.first?.string, old: &hoursTuple.0)
            let rightHours = chechTimerTupleChange(new: tuple.hours.last?.string, old: &hoursTuple.1)
            
            // 檢查並更新分鐘部分的變化
            let leftMinutes = chechTimerTupleChange(new: tuple.minutes.first?.string, old: &minutesTuple.0)
            let rightMinutes = chechTimerTupleChange(new: tuple.minutes.last?.string, old: &minutesTuple.1)
            
            // 檢查並更新秒部分的變化
            let leftSeconds = chechTimerTupleChange(new: tuple.seconds.first?.string, old: &secondsTuple.0)
            let rightSeconds = chechTimerTupleChange(new: tuple.seconds.last?.string, old: &secondsTuple.1)
            
            // 通知委派數字部分的變化
            delegate?.countdownTime(hours: (leftHours, rightHours), minutes: (leftMinutes, rightMinutes), seconds: (leftSeconds, rightSeconds))
        }
    }
    
    /// 計算給定秒數所對應的小時、分鐘和秒數，並以元組形式返回。
    ///
    /// - Parameter seconds: 總秒數。
    /// - Returns: 包含小時、分鐘和秒的字串格式元組。
    fileprivate func countdownTimeTuple(seconds: Int) -> (hours: String, minutes: String, seconds: String) {
        let hours = seconds / 60 / 60
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        
        return (hours: String(format:"%02d", hours), minutes: String(format:"%02d", minutes), seconds: String(format:"%02d", seconds))
    }
    
    /// 檢查並更新計時數字的變化。
    ///
    /// - Parameters:
    ///   - new: 當前的計時數字。
    ///   - old: 之前的計時數字。該參數將被更新為新的計時數字。
    /// - Returns: 如果數字變化了，返回新的數字；否則返回 `nil`。
    fileprivate func chechTimerTupleChange(new: String?, old: inout String?) -> String? {
        guard new != old else { return nil }
        old = new
        return old
    }
}

extension CountdownTimerDelegate {
    
    /// 當倒計時結束時，默認實現此方法。
    func countdownTimerFinish() {}
    
    /// 當倒計時有更新時，默認實現此方法，以時間的格式傳遞。
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {}
    
    /// 當倒計時有更新時，默認實現此方法，以個別數字的格式傳遞。
    func countdownTime(hours: (String?, String?), minutes: (String?, String?), seconds: (String?, String?)) {}
}


extension Character {
    /// SwifterSwift: String from character.
    ///
    ///        Character("a").string -> "a"
    ///
    var string: String {
        return String(self)
    }
}
