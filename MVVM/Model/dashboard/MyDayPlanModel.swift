//
//  MyDayPlan.swift
//  GoDairy
//
//  Created by San eforce on 23/08/25.
//

import Foundation

struct mydayplanDataResponse: Codable {
    let id: Int?
    let name: String?
    let etabs: String?
    let fwflg: String?
    let place_involved: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case etabs = "ETabs"
        case fwflg = "FWFlg"
        case place_involved = "Place_Involved"
    }
}

struct mydayPlanCheckResponse: Codable {
    let CheckEndKM: Int
    let CheckEndDT: String
    let CheckOnduty: Int
    let checkMOT: Int
    let Todaycheckin_Flag: Int
    let Checkdayplan: [CheckDayPlanData]?
}

struct CheckDayPlanData: Codable {
    let sf_code: String
    let Cnt: Int
    let wtype: String
    
    enum CodingKeys: String, CodingKey {
        case sf_code = "sf_code"
        case Cnt = "Cnt"
        case wtype = "wtype"
    }
}

struct mydayPlanSaveResponse: Codable {
    
}


