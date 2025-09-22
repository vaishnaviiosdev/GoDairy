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

//"Sl_no":"44",
//"SF_Mobile":"8886622371",
//"Sf_Code":"MGR80",
//"Permissiondate":"025-09-07",
//"FromTime":"05:47 AM",
//"Applieddate":"03-09-2025",
//"ToTime":"06:47 AM",
//"Reason":"Jjjjjjj",
//"Noof_hours":"",
//"FieldForceName":"G RAMESH",
//"Reporting_To_SF":"MGR93",
//"Designation":"SALES PERSON",
//"HQ":"2524-PLMNR - MARKETING",
//"EmpCode":"801090",
//"Submission_date":"025-09-07",
//"Approval_Flag":2,
//"Rejected_Reason":"",
//"Pstatus_Sf":"MGR80"
