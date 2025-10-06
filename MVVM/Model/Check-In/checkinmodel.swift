//
//  checkinmodel.swift
//  GoDairy
//
//  Created by San eforce on 30/09/25.
//

import Foundation

struct checkinSaveData: Codable {
    let query: String?
    let success: Bool
    let Msg: String
}

struct ImageUploadResponse: Decodable {
    let Qry: String?
    let success: Bool?
    let message: String?
    let url: String?
}
