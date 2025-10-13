//
//  advanceStatusModel.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import Foundation

struct advStatusDataResponse: Codable, Identifiable {
    var id = UUID().uuidString
    let eDate: String?
    let From_Date: String?
    let To_Date: String?
    let AdvTyp: String?
    let AdvLoc: String?
    let AdvPurp: String?
    let AdvAmt: Int?
    let AdvSettle: String?
    let ApprDt: String?
    let ApprBy: String?
    let ApprByNm: String?
    let flag: Int?
    let LStatus: String?
    let StusClr: String?
    
    enum CodingKeys: String, CodingKey {
        case eDate, From_Date, To_Date, AdvTyp, AdvLoc, AdvPurp, AdvAmt, AdvSettle, ApprDt, ApprBy, ApprByNm, flag, LStatus, StusClr
    }
}
