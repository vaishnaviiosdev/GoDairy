//
//  MissedPunchModel.swift
//  GoDairy
//
//  Created by San eforce on 04/09/25.
//

import Foundation

struct MissedPunchDataResponse: Codable, Identifiable {
    var id: String { name }  // Stable ID
    
    let name: String
    let aflag: String
    let name1: String
    let endTime: String?
    let checkinTime: String
    let checkoutTime: String

    enum CodingKeys: String, CodingKey {
        case name
        case aflag = "Aflag"
        case name1
        case endTime = "End_Time"
        case checkinTime = "Checkin_Time"
        case checkoutTime = "COutTime"
    }
    
    // Custom decode to clean brackets automatically
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        aflag = try container.decode(String.self, forKey: .aflag)
        let rawName1 = try container.decode(String.self, forKey: .name1)
        name1 = rawName1.replacingOccurrences(of: "[", with: "")
                         .replacingOccurrences(of: "]", with: "")
                         .trimmingCharacters(in: .whitespacesAndNewlines)
        endTime = try container.decodeIfPresent(String.self, forKey: .endTime)
        checkinTime = try container.decode(String.self, forKey: .checkinTime)
        checkoutTime = try container.decode(String.self, forKey: .checkoutTime)
    }
}

struct missedPunchSaveResponse: Codable {
    let Msg: String
    let MsgID: String
    let success: Bool
    let Query: String
    
    enum CodingKeys: String, CodingKey {
        case Msg = "Msg"
        case MsgID = "MsgID"
        case success = "success"
        case Query = "Query"
    }
}
