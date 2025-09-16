//
//  approvalMissedPunchModel.swift
//  GoDairy
//
//  Created by San eforce on 16/09/25.
//

import Foundation

struct approvalMissedPunchModel: Codable, Identifiable {
    var id = UUID().uuidString
    let Sf_Code: String
    let SFNm: String
    let Shift_Name: String
    let Rejectdate: String
    let Missed_punch_date: String
    let Missed_punch_Flag: Int
    let Submission_date: String
    let Reason: String
    let Checkin_Time: String
    let Checkout_Tme: String
    let MPStatus: String
    let StusClr: String
    let RejectReason: String
    
    enum CodingKeys: String, CodingKey {
        case Sf_Code = "Sf_Code"
        case SFNm = "SFNm"
        case Shift_Name = "Shift_Name"
        case Rejectdate = "Rejectdate"
        case Missed_punch_date = "Missed_punch_date"
        case Missed_punch_Flag = "Missed_punch_Flag"
        case Submission_date = "Submission_date"
        case Reason = "Reason"
        case Checkin_Time = "Checkin_Time"
        case Checkout_Tme = "Checkout_Tme"
        case MPStatus = "MPStatus"
        case StusClr = "StusClr"
        case RejectReason = "RejectReason"
    }
}
