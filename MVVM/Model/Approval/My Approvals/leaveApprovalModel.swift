//
//  leaveApprovalModel.swift
//  GoDairy
//
//  Created by San eforce on 17/09/25.
//

import Foundation

struct leaveApprovalDataResponse: Codable, Identifiable {
    
    var id = UUID().uuidString
    let SF_Mobile: String
    let Sf_Code: String
    let Leave_Id: Int
    let Reason: String
    let Applieddate: String
    let Address: String
    let FieldForceName: String
    let Reporting_To_SF: String
    let Designation: String
    let HQ: String
    let EmpCode: String
    let From_Date: String
    let To_Date: String
    let LeaveDays: Int
    let Division_Code: Int
    let sf_Designation_Short_Name: String
    let Leave_Type: Int
    let Leave_Name: String
    
    enum CodingKeys: String, CodingKey {
        case SF_Mobile = "SF_Mobile"
        case Sf_Code = "Sf_Code"
        case Leave_Id = "Leave_Id"
        case Reason = "Reason"
        case Applieddate = "Applieddate"
        case Address = "Address"
        case FieldForceName = "FieldForceName"
        case Reporting_To_SF = "Reporting_To_SF"
        case Designation = "Designation"
        case HQ = "HQ"
        case EmpCode = "EmpCode"
        case From_Date = "From_Date"
        case To_Date = "To_Date"
        case LeaveDays = "LeaveDays"
        case Division_Code = "Division_Code"
        case sf_Designation_Short_Name = "sf_Designation_Short_Name"
        case Leave_Type = "Leave_Type"
        case Leave_Name = "Leave_Name"
    }
}

struct leaveApprovalApprovalData: Codable {
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}

struct leaveApprovalRejectData: Codable {
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}
