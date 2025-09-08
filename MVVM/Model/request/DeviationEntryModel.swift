//
//  DeviationEntryModel.swift
//  GoDairy
//
//  Created by San eforce on 05/09/25.
//

import Foundation

struct DeviationEntryDataResponse: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct DeviationEntrySaveResponse: Codable {
    let Msg: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case Msg = "Msg"
        case success = "success"
    }
}
