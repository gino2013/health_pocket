//
//  PharmacyCellViewModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/5/22.
//

import Foundation
import GoogleMaps

class PharmacyCellViewModel {
    // Top View
    let hospitalName: String
    let distance: String
    // Middle View
    let isReserve: String
    let receiveMedicineTimes: String
    // Bottom View
    let address: String
    let contactPhone: String
    let businessHours: [String]
    let pharmacyId: String
    var latitude: Double
    var longitude: Double
    let isPartner: Bool
    var isSelectCell: Bool
    var markerInfo: GMSMarker?
    
    init(hospitalName: String, distance: String, isReserve: String, receiveMedicineTimes: String, address: String, contactPhone: String, businessHours: [String], pharmacyId: String, latitude: Double, longitude: Double, isPartner: Bool, isSelectCell: Bool, markerInfo: GMSMarker? = nil) {
        self.hospitalName = hospitalName
        self.distance = distance
        self.isReserve = isReserve
        self.receiveMedicineTimes = receiveMedicineTimes
        self.address = address
        self.contactPhone = contactPhone
        self.businessHours = businessHours
        self.pharmacyId = pharmacyId
        self.latitude = latitude
        self.longitude = longitude
        self.isPartner = isPartner
        self.isSelectCell = isSelectCell
        self.markerInfo = markerInfo
    }
}

func pharmacyCellViewModelSampleData() -> [PharmacyCellViewModel] {
    var a = [PharmacyCellViewModel]()
    /*
    a.append(PharmacyCellViewModel(hospitalName: "參天藥局", distance: "0.4", isReserve: "可預約", receiveMedicineTimes: "前次領藥", address: "台北市忠孝東路五段459號1樓", isPartner: true, isSelectCell: false))
    a.append(PharmacyCellViewModel(hospitalName: "自然藥局", distance: "0.1", isReserve: "可預約", receiveMedicineTimes: "前次領藥", address: "台北市羅斯福路四段459號1樓", isPartner: true, isSelectCell: false))
    a.append(PharmacyCellViewModel(hospitalName: "道德藥局", distance: "0.4", isReserve: "", receiveMedicineTimes: "前次領藥", address: "台北市和平東路三段459號1樓", isPartner: false, isSelectCell: false))
    a.append(PharmacyCellViewModel(hospitalName: "大道藥局", distance: "0.4", isReserve: "可預約", receiveMedicineTimes: "前次領藥", address: "台北市市民大道二段459號1樓", isPartner: true, isSelectCell: false))
    a.append(PharmacyCellViewModel(hospitalName: "參天藥局", distance: "0.4", isReserve: "", receiveMedicineTimes: "前次領藥", address: "台北市迪化街459號1樓", isPartner: false, isSelectCell: false))
    a.append(PharmacyCellViewModel(hospitalName: "參天上院藥局", distance: "0.4", isReserve: "可預約", receiveMedicineTimes: "前次領藥", address: "台北市仁愛路五段449號1樓", isPartner: true, isSelectCell: false))
    */
    return a
}

func searchResultSampleData() -> [PharmacyCellViewModel] {
    // 25.037049003776826, 121.55375958629661
    var a = [PharmacyCellViewModel]()
    /*
    a.append(PharmacyCellViewModel(hospitalName: "國泰綜合醫院", distance: "0.4", isReserve: "可預約", receiveMedicineTimes: "前次領藥", address: "106台北市大安區仁愛路四段280號", isPartner: true, isSelectCell: false))
    // 25.03498704386389, 121.557690835582
    a.append(PharmacyCellViewModel(hospitalName: "國泰牙醫診所", distance: "0.1", isReserve: "可預約", receiveMedicineTimes: "前次領藥", address: "110台北市信義區光復南路449之3號", isPartner: true, isSelectCell: false))
    // 25.07276206611597, 121.6612009932541
    a.append(PharmacyCellViewModel(hospitalName: "汐止國泰綜合醫院", distance: "0.4", isReserve: "", receiveMedicineTimes: "前次領藥", address: "221新北市汐止區建成路59巷2號", isPartner: false, isSelectCell: false))
    */
    return a
}
