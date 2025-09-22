//
//  AdvanceApprovalHistoryModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 18/09/25.
//

import Foundation

class AdvanceApprovalHistoryModel: Codable , Identifiable {
    var id = UUID().uuidString
    let SF: String
    let eKey: String
    let eDate: String
    let From_Date: String
    let To_Date: String
    let AdvTyp: String
    let AdvLoc: String
    let AdvPurp: String
    let AdvAmt: Double
    let AdvSettle: String
    let ApprDt: String
    let ApprBy: String
    let ApprByNm: String
    let flag: Int
    let LStatus: String
    let StusClr: String
    
    enum CodingKeys: String, CodingKey {
        case SF = "SF"
        case eKey = "eKey"
        case eDate = "eDate"
        case From_Date = "From_Date"
        case To_Date = "To_Date"
        case AdvTyp = "AdvTyp"
        case AdvLoc = "AdvLoc"
        case AdvPurp = "AdvPurp"
        case AdvAmt = "AdvAmt"
        case AdvSettle = "AdvSettle"
        case ApprDt = "ApprDt"
        case ApprBy = "ApprBy"
        case ApprByNm = "ApprByNm"
        case flag = "flag"
        case LStatus = "LStatus"
        case StusClr = "StusClr"
    }
}



