//
//  PermissionRequestModel.swift
//  GoDairy
//
//  Created by San eforce on 02/09/25.
//

import Foundation

struct PermissionRequestModel: Codable {
    let id: String
    let name: String
    let Sft_STime: String
    let sft_ETime: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case Sft_STime = "Sft_STime"
        case sft_ETime = "sft_ETime"
    }
}


