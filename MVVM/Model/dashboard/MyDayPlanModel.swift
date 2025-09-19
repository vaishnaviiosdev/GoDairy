//
//  MyDayPlan.swift
//  GoDairy
//
//  Created by San eforce on 23/08/25.
//

import Foundation

struct mydayplanworkTypeResponse: Codable {
    let id: Int
    let name: String
    let ETabs: String
    let FWFlg: String
    let Place_Involved: String
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
}




