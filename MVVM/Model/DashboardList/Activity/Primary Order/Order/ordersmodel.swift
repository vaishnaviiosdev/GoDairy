//
//  ordersmodel.swift
//  GoDairy
//
//  Created by San eforce on 15/10/25.
//

import Foundation

struct categoryDataResponse: Codable, Identifiable {
    var id = UUID().uuidString
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

struct categoryTypeDataResponse: Codable, Identifiable {
    var id = UUID().uuidString
    let name: String
    let GroupId: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case GroupId = "GroupId"
    }
}
