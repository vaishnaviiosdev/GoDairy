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

struct SubmitDayPlanData: Codable {
    let success: Bool?
    let msg: String?
}

struct todayDashboardData: Codable {
    let TodayData: todayData?
}

struct todayData: Codable {
    let SF_Code: String
    let SF_Name: String
    let login_date: loginDateData?
    let Shft: ShftData?
    let ShftE: ShftEData?
    let STm: STmData?
}

struct loginDateData: Codable {
    let WrkDate: String
    let SFT_Name: String
}

struct ShftData: Codable {
    let date: String
    let timezone_type: Int
    let timezone: String
}

struct ShftEData: Codable {
    let date: String
    let timezone_type: Int
    let timezone: String
}

struct STmData: Codable {
    let AttTm: String
    let ET: String
    let DayStatus: String
    let Status: String
}




