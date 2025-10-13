//
//  DeviationEntryApprovalModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 23/09/25.
//

import Foundation

struct DeviationEntryApprovalModel: Codable, Identifiable {
    
    var id = UUID().uuidString
    let Deviation_Id :Int
    let SF_Mobile: String
    let Sf_Code: String
    let Reason: String
    let Applieddate: String
    let FieldForceName: String
    let Reporting_To_SF: String
    let Designation: String
    let HQ: String
    let EmpCode: String
    let Deviation_Date: String
    let sf_Designation_Short_Name: String
    let DeviationName: String
    
    enum CodingKeys: String, CodingKey {
        case Deviation_Id = "Deviation_Id"
        case SF_Mobile = "SF_Mobile"
        case Sf_Code = "Sf_Code"
        case Reason = "Reason"
        case Applieddate = "Applieddate"
        case FieldForceName = "FieldForceName"
        case Reporting_To_SF = "Reporting_To_SF"
        case Designation = "Designation"
        case HQ = "HQ"
        case EmpCode = "EmpCode"
        case Deviation_Date = "Deviation_Date"
        case sf_Designation_Short_Name = "sf_Designation_Short_Name"
        case DeviationName = "DeviationName"
        
    }
}

