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

struct permissionTakenHrsModel: Codable {
    let tknHrS: String
    
    enum CodingKeys: String, CodingKey {
        case tknHrS = "tknHrS"
    }
}

struct permissionSaveModel: Codable {
    let Msg: String
    let success: Bool
    let Query: String
    
    enum CodingKeys: String, CodingKey {
        case Msg = "Msg"
        case success = "success"
        case Query = "Query"
    }
}


