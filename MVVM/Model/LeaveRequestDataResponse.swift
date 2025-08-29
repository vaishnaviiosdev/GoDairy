//
//  LeaveRequestModel.swift
//  GoDairy
//
//  Created by San eforce on 28/08/25.
//

import Foundation

struct LeaveRequestDataResponse: Codable, Identifiable {
    var id: String { LeaveCode }
    let SFCode: String
    let LeaveCode: String
    let LeaveValue: Int
    let LeaveAvailability: Double
    let LeaveTaken: Double
    let Leave_SName: String
    let Leave_Name: String
    
    enum CodingKeys: String, CodingKey {
        case SFCode = "SFCode"
        case LeaveCode = "LeaveCode"
        case LeaveValue = "LeaveValue"
        case LeaveAvailability = "LeaveAvailability"
        case LeaveTaken = "LeaveTaken"
        case Leave_SName = "Leave_SName"
        case Leave_Name = "Leave_Name"
    }
}

struct LeaveShiftTimeDataResponse: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
