//
//  GateInModel.swift
//  GoDairy
//
//  Created by San eforce on 16/10/25.
//

import Foundation

struct GateInDataResponse: Codable {
    let Msg: String?
    let success: Bool?
    let Query: String?
}

struct GateOUTDataResponse: Codable {
    let Msg: String?
    let success: Bool?
    let Query: String?
    let UQuery: String?
}

struct GateInOutListDataResponse: Codable, Identifiable {
    var id = UUID().uuidString
    let HQLoc: String?
    let time: String?
    let Itime: String?
    let Otime: String?
    let latLng: String?
    let OlatLng: String?
    
    enum CodingKeys: String, CodingKey {
        case HQLoc = "HQLoc"
        case time = "time"
        case Itime = "Itime"
        case Otime = "Otime"
        case latLng = "latLng"
        case OlatLng = "OlatLng"
    }
}
