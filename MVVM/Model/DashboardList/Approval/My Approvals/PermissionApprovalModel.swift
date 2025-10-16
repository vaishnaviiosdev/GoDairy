//
//  PermissionApprovalModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 19/09/25.
//

import Foundation


struct PermissionApprovalModel: Codable, Identifiable {
    
    var id = UUID().uuidString
    let Sl_no :String
    let SF_Mobile: String
    let Sf_Code: String
    let Permissiondate: String
    let FromTime: String
    let Applieddate: String
    let ToTime: String
    let Reason: String
    let Noof_hours: String
    let FieldForceName: String
    let Reporting_To_SF: String
    let Designation: String
    let HQ: String
    let EmpCode: String
    let Submission_date: String
    let Approval_Flag: Int
    let Rejected_Reason: String
    let Pstatus_Sf: String
    
    enum CodingKeys: String, CodingKey {
        case Sl_no = "Sl_no"
        case SF_Mobile = "SF_Mobile"
        case Sf_Code = "Sf_Code"
        case Permissiondate = "Permissiondate"
        case FromTime = "FromTime"
        case Applieddate = "Applieddate"
        case ToTime = "ToTime"
        case Reason = "Reason"
        case Noof_hours = "Noof_hours"
        case FieldForceName = "FieldForceName"
        case Reporting_To_SF = "Reporting_To_SF"
        case Designation = "Designation"
        case HQ = "HQ"
        case EmpCode = "EmpCode"
        case Submission_date = "Submission_date"
        case Approval_Flag = "Approval_Flag"
        case Rejected_Reason = "Rejected_Reason"
        case Pstatus_Sf = "Pstatus_Sf"
    }
}

