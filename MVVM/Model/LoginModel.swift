//
//  LoginModel.swift
//  GoDairy
//
//  Created by San eforce on 19/08/25.
//

import Foundation

struct DataItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let base_url: String
}

struct LoginResponse: Codable {
    let success: Bool
    let data: [UserData]?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "Data"
    }
}

struct UserData: Codable {
    let sfCode: String?
    let divisionCode: String?
    let sfName: String?
    
    enum CodingKeys: String, CodingKey {
        case sfCode = "Sf_code"
        case divisionCode = "Division_Code"
        case sfName = "Sf_Name"
    }
}
