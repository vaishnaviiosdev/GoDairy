//
//  weekOffModel.swift
//  GoDairy
//
//  Created by San eforce on 09/09/25.
//

import Foundation

struct weekOffDataResponse: Codable {
    let response: [weekOffResponse]?
    let success: Bool
}

struct weekOffResponse: Codable, Identifiable {
    var id = UUID()
    let WrkTyp: String
    let wkDate: String
    let wkDt: String
    let DtNm: String
    let Rmks: String
    let sbmtOn: String
    
    enum CodingKeys: String, CodingKey {
        case WrkTyp = "WrkTyp"
        case wkDate = "wkDate"
        case wkDt = "wkDt"
        case DtNm = "DtNm"
        case Rmks = "Rmks"
        case sbmtOn = "sbmtOn"
    }
}
