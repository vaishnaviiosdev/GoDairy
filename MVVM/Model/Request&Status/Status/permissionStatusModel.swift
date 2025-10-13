//
//  permissionStatusModel.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import Foundation

struct permissionDataResponse: Codable, Identifiable {
    var id = UUID().uuidString
    let Permissiondate: String?
    let Approval_Flag: Int?
    let Submission_date: String?
    let Created_Date: String?
    let Approveddate: String?
    let FromTime: String?
    let ToTime: String?
    let Reason: String?
    let Noof_hours: String?
    let PStatus: String?
    let StusClr: String?
    let Rejected_Reason: String?
    
    enum CodingKeys: String, CodingKey {
        case Permissiondate, Approval_Flag, Submission_date, Created_Date, Approveddate, FromTime, ToTime, Reason, Noof_hours, PStatus, StusClr, Rejected_Reason
    }
}
