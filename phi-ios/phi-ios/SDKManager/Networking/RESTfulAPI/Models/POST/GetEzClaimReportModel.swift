//
//  GetEzClaimReportModel.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/9/19.
//

import Foundation

struct GetEzClaimReportModel {
    let userProfile: UserProfile
    let disease: Disease
    let policy: [Policy]
    
    // 將模型轉換為 JSON 格式
    func toJSON() -> JSON {
        var json = JSON()
        
        // 將 userProfile 添加到 JSON 中
        json["userProfile"] = userProfile.toJSON()
        
        // 將 disease 添加到 JSON 中
        json["disease"] = disease.toJSON()
        
        // 將 policy 數組轉換為 JSON 數組
        json["policy"] = JSON(policy.map { $0.toJSON() })
        
        return json
    }
    
    // 初始化 GetEzClaimReportModel
    init(userProfile: UserProfile, disease: Disease, policy: [Policy]) {
        self.userProfile = userProfile
        self.disease = disease
        self.policy = policy
    }
}

// 定義 UserProfile 模型
struct UserProfile {
    let birthday: String
    let gender: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["birthday"].string = birthday
        json["gender"].string = gender
        return json
    }
    
    init(birthday: String, gender: String) {
        self.birthday = birthday
        self.gender = gender
    }
}

// 定義 Disease 模型
struct Disease {
    let diseaseName: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["diseaseName"].string = diseaseName
        return json
    }
    
    init(diseaseName: String) {
        self.diseaseName = diseaseName
    }
}

// 定義 Policy 模型
struct Policy {
    let productCode: String
    let unit: String
    let contractDate: String
    
    func toJSON() -> JSON {
        var json = JSON()
        json["productCode"].string = productCode
        json["unit"].string = unit
        json["contractDate"].string = contractDate
        return json
    }
    
    init(productCode: String, unit: String, contractDate: String) {
        self.productCode = productCode
        self.unit = unit
        self.contractDate = contractDate
    }
}
