//
//  DeviationStatusModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 24/09/25.
//

import Foundation


struct DeviationStatusModel: Codable, Identifiable {
    var id = UUID()
    let sf_code: String
    let Deviation_Id: Int
    let Created_Date: String
    let Reason: String
    let Deviation_Type: String
    let Deviation_Date: String
    let LastUpdt_Date: String
    let DStatus: String
    let StusClr: String
    let Rejected_Reason: String
    let Devi_Active_Flag : Int
    
    enum CodingKeys: String, CodingKey {
        case sf_code = "sf_code"
        case Deviation_Id = "Deviation_Id"
        case Created_Date = "Created_Date"
        case Reason = "Reason"
        case Deviation_Type = "Deviation_Type"
        case Deviation_Date = "Deviation_Date"
        case LastUpdt_Date = "LastUpdt_Date"
        case DStatus = "DStatus"
        case StusClr = "StusClr"
        case Rejected_Reason = "Rejected_Reason"
        case Devi_Active_Flag = "Devi_Active_Flag"
    }
}



