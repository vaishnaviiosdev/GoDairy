//
//  leaveCancelModel.swift
//  GoDairy
//
//  Created by San eforce on 08/09/25.
//

import Foundation

struct leaveCancelDataResponse: Codable,Identifiable {
    var id = UUID()
    let sf_code: String?
    let Leave_Id: Int?
    let showflag: Int?
    let Created_Date: String?
    let cancelreason: String?
    let Reason: String?
    let Leave_Type: String?
    let From_Date: String?
    let LastUpdt_Date: String?
    let To_Date: String?
    let No_of_Days: String?
    let LStatus: String?
    let StusClr: String?
    let Rejected_Reason: String?
    let Leave_Active_Flag: String?
    
    enum CodingKeys: String, CodingKey {
        case sf_code = "sf_code"
        case Leave_Id = "Leave_Id"
        case showflag = "showflag"
        case Created_Date = "Created_Date"
        case cancelreason = "cancelreason"
        case Reason = "Reason"
        case Leave_Type = "Leave_Type"
        case From_Date = "From_Date"
        case LastUpdt_Date = "LastUpdt_Date"
        case To_Date = "To_Date"
        case No_of_Days = "No_of_Days"
        case LStatus = "LStatus"
        case StusClr = "StusClr"
        case Rejected_Reason = "Rejected_Reason"
        case Leave_Active_Flag = "Leave_Active_Flag"
    }
}
