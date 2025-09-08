//
//  WeelOffModel.swift
//  GoDairy
//
//  Created by San eforce on 05/09/25.
//

import Foundation

struct WeekOffModelResponse: Codable {
    let Msg: String
    let success: Bool
    let Query: String
    
    enum CodingKeys: String, CodingKey {
        case Msg = "Msg"
        case success = "success"
        case Query = "Query"
    }
}
