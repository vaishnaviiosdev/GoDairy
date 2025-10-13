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

struct TodayData: Codable {
    let SF_Code: String
    let SF_Name: String
    let login_date: DateData?
    let WrkDate: String
    let SFT_Name: String
    let Shft: DateData?
    let ShftE: DateData?
    let STm: DateData?
    let AttTm: String
    let ET: String
    let dv: Int
    let Rw: String
    let Status: String
    let ACtOffHrs: Int
    let AttDate: String
    let ImgName: String
    let EImgName: String
    let SImgName: String
    let AttDtNm: String
    let DayStatus: String
    let StaColor: String
    let GeoIn: String?
    let Extin: String?
    let ExtStartTtime: String
    let ExtEndtime: String
    let GeoOut: String?
    let Extout: String?
    let lat_long: String
    let HQNm: String
}

struct DateData: Codable {
    let date: String
    let timezone_type: Int
    let timezone: String
}

struct monthlyDashboardData: Codable {
    let leave: Int
    let Newjoin: Int
    let Permission: Int
    let Advance: Int
    let vwOnduty: Int
    let vwmissedpunch: Int
    let vwExtended: Int
    let TountPlanCount: Int
    let FlightAppr: Int
    let HolidayCount: Int
    let ClaimCount: Int
    let DeviationC: Int
    let CancelLeave: Int
    let ExpList: Int
}

struct monthlyViewAllData: Codable, Identifiable {
    var id = UUID().uuidString
    let Attndt: String?
    let login_date: String?
    let WrkDate: String?
    let SFT_Name: String?
    let Shft: String?
    let ShftE: String?
    let AttTm: String?
    let ET: String?
    let Geoin: String?
    let Geoout: String?
    let Loc: String?
    let DayStatus: String?
    let StusClr: String?
    
    enum CodingKeys: String, CodingKey {
        case Attndt = "Attndt"
        case login_date = "login_date"
        case WrkDate = "WrkDate"
        case SFT_Name = "SFT_Name"
        case Shft = "Shft"
        case ShftE = "ShftE"
        case AttTm = "AttTm"
        case ET = "ET"
        case Geoin = "Geoin"
        case Geoout = "Geoout"
        case Loc = "Loc"
        case DayStatus = "DayStatus"
        case StusClr = "StusClr"
    }
}







