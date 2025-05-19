//
//  ReminderCellViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/7/4.
//

import Foundation

struct ReminderSection {
    let title: String
    let items: [ReminderCellViewModel]
}

class ReminderCellViewModel {
    let cellIndex: Int
    let cellSection: Int
    let iconImageName: String
    let mainTitle: String
    let subTitle: String
    let infoText: String
    var addBottomLine: Bool
    
    init(cellIndex: Int, cellSection: Int, iconImageName: String, mainTitle: String, subTitle: String, infoText: String, addBottomLine: Bool) {
        self.cellIndex = cellIndex
        self.cellSection = cellSection
        self.iconImageName = iconImageName
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.infoText = infoText
        self.addBottomLine = addBottomLine
    }
}

struct ReminderSectionExt {
    let title: String
    let items: [ReminderCellViewModelExt]
}

class ReminderCellViewModelExt {
    let cellIndex: Int
    let cellSection: Int
    var iconImageName: String
    var addBottomLine: Bool
    var reminderInfo: ReminderRspModel
    
    init(cellIndex: Int, cellSection: Int, iconImageName: String, addBottomLine: Bool, reminderInfo: ReminderRspModel) {
        self.cellIndex = cellIndex
        self.cellSection = cellSection
        self.iconImageName = iconImageName
        self.addBottomLine = addBottomLine
        self.reminderInfo = reminderInfo
    }
}

func reminderCellViewModelSampleData() -> [ReminderSection] {
    let a = [
        ReminderSection(title: "08:30", items: [
            ReminderCellViewModel(cellIndex: 1, cellSection: 0, iconImageName: "Pill_Default", mainTitle: "停敏膜衣錠", subTitle: "糖尿病血壓控制", infoText: "1錠", addBottomLine: true),
            ReminderCellViewModel(cellIndex: 2, cellSection: 0, iconImageName: "Pill_Done", mainTitle: "止痛藥 ", subTitle: "膝蓋關節止痛藥", infoText: "1錠", addBottomLine: false)
            
        ]),
        ReminderSection(title: "12:30", items: [
            ReminderCellViewModel(cellIndex: 1, cellSection: 1, iconImageName: "Pill_Default", mainTitle: "止痛藥 ", subTitle: "膝蓋關節止痛藥", infoText: "1錠", addBottomLine: false)
        ]),
        ReminderSection(title: "19:30", items: [
            ReminderCellViewModel(cellIndex: 1, cellSection: 2, iconImageName: "Pill_None", mainTitle: "停敏膜衣錠", subTitle: "糖尿病血壓控制", infoText: "1錠", addBottomLine: true),
            ReminderCellViewModel(cellIndex: 2, cellSection: 2, iconImageName: "Pill_Default", mainTitle: "止痛藥 ", subTitle: "膝蓋關節止痛藥", infoText: "1錠", addBottomLine: true),
            ReminderCellViewModel(cellIndex: 3, cellSection: 2,iconImageName: "Pill_Done", mainTitle: "停敏膜衣錠", subTitle: "糖尿病血壓控制", infoText: "1錠", addBottomLine: false)
        ])
    ]
    
    return a
}
