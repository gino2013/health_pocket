//
//  PolicyInfoCellViewModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/24.
//

import Foundation

class PolicyInfoCellViewModel {
    var cellId: String // 改為使用 UUID 字串
    var cellInfo: PolicyInformation
    
    init(cellInfo: PolicyInformation) {
        self.cellId = UUID().uuidString // 使用 UUID 作為唯一標識
        self.cellInfo = cellInfo
    }
}
