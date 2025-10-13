//
//  GeoTaggingModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 07/10/25.
//

import Foundation

struct GeoTaggingModelResponse: Codable {
    let response: [GeoTaggingModel]?
    let success: Bool
    let radius : Int
}

struct GeoTaggingModel: Codable, Identifiable {
    var id = UUID().uuidString
    let title: String
    let lat: String
    let lng: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case lat = "lat"
        case lng = "lng"
    }
}
