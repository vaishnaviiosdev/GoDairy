//
//  approvalPermissionmodel.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import Foundation

struct approvalPermissionDataResponse: Codable, Identifiable {
    let id = UUID().uuidString
    
    let Sf_Code: String
    let SFNm: String
    let Permissiondate: String
    let Approval_Flag: Int
    let Submission_date: String
    let Created_Date: String
    let Approveddate: String
    let FromTime: String
    let ToTime: String
    let Reason: String
    let Noof_hours: String
    let PStatus: String
    let StusClr: String
    let Rejected_Reason: String
    
    enum CodingKeys: String, CodingKey {
        case Sf_Code = "Sf_Code"
        case SFNm = "SFNm"
        case Permissiondate = "Permissiondate"
        case Approval_Flag = "Approval_Flag"
        case Submission_date = "Submission_date"
        case Created_Date = "Created_Date"
        case Approveddate = "Approveddate"
        case FromTime = "FromTime"
        case ToTime = "ToTime"
        case Reason = "Reason"
        case Noof_hours = "Noof_hours"
        case PStatus = "PStatus"
        case StusClr = "StusClr"
        case Rejected_Reason = "Rejected_Reason"
    }
}
