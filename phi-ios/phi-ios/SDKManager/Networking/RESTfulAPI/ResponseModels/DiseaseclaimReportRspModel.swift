//
//  DiseaseclaimReportRspModel.swift
//  phi-ios
//
//  Created by Kenneth on 2024/9/19.
//

import Foundation

class DiseaseclaimReportRspModel: JSONDecodable {
    public var pdfFile: String
    
    required public init(json: JSON) {
        pdfFile = json["pdfFile"].stringValue
    }
}
