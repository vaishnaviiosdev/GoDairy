//
//  LeaveApprovalHistoryModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 17/09/25.
//

import Foundation

class LeaveApprovalHistoryModel: Codable , Identifiable {
    var id = UUID().uuidString
    let sf_code: String
    let Leave_Id: String
    let SFNm: String
    let showflag: String
    let Created_Date: String
    let cancelreason: String
    let Reason: String
    let Leave_Type: String
    let From_Date: String
    let LastUpdt_Date: String
    let To_Date: String
    let No_of_Days: Double
    let LStatus: String
    let StusClr: String
    let Rejected_Reason: String
    let Leave_Active_Flag: String
    
    enum CodingKeys: String, CodingKey {
        case sf_code = "sf_code"
        case Leave_Id = "Leave_Id"
        case SFNm = "SFNm"
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


//{"sf_code":"MGR9366","Leave_Id":"518","SFNm":"RAGU M","showflag":"1","Created_Date":"16-09-2025","cancelreason":"0","Reason":"shsh","Leave_Type":"Loss of Pay","From_Date":"17-09-2025","LastUpdt_Date":"17-09-2025","To_Date":"17-09-2025","No_of_Days":1,"LStatus":"Reject","StusClr":"rgb(255,0,0)  !important","Rejected_Reason":null,"Leave_Active_Flag":"1"}
