//
//  AdvanceRequestModel.swift
//  GoDairy
//
//  Created by San eforce on 01/09/25.
//

import Foundation

struct advanceRequestModelData: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

