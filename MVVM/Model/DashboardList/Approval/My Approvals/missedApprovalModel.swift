//
//  missedApprovalModel.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import Foundation

struct missedApprovalDataResponse: Codable {
    let Sf_Code: String
    let Sl_No: Int
    let mobilenumber: String
    let Shift_Name: String
    let Checkin_Tme: String
    let Sf_name: String
    let Checkout_Tme: String
    let Reason: String
    let Missed_punch_date: String
    let AppliedDate: String
    let Reporting_To_SF: String
    let Designation: String
    let HQ: String
    let EmpCode: String
    
    enum CodingKeys: String, CodingKey {
        case Sf_Code = "Sf_Code"
        case Sl_No = "Sl_No"
        case mobilenumber = "mobilenumber"
        case Shift_Name = "Shift_Name"
        case Checkin_Tme = "Checkin_Tme"
        case Sf_name = "Sf_name"
        case Checkout_Tme = "Checkout_Tme"
        case Reason = "Reason"
        case Missed_punch_date = "Missed_punch_date"
        case AppliedDate = "AppliedDate"
        case Reporting_To_SF = "Reporting_To_SF"
        case Designation = "Designation"
        case HQ = "HQ"
        case EmpCode = "EmpCode"
    }
}

struct missedApprovalApprovalData: Codable {
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}

struct missedApprovalRejectData: Codable {
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}

