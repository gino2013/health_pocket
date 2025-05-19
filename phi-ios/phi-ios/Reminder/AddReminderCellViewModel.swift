//
//  AddReminderCellViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/8.
//

import Foundation

class AddReminderCellViewModel {
    var cellId: Int
    var cellInfo: PrescriptionInfo
    var addBottomLine: Bool
    var selectStatus: AddReminderTViewCellSelectStatus
    
    init(cellId: Int, cellInfo: PrescriptionInfo, addBottomLine: Bool, selectStatus: AddReminderTViewCellSelectStatus) {
        self.cellId = cellId
        self.cellInfo = cellInfo
        self.addBottomLine = addBottomLine
        self.selectStatus = selectStatus
    }
}
