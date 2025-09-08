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
