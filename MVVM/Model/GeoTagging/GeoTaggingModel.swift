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
 //   let id :String
    let title: String
//    let address: String
    let lat: String
    let lng: String
//    let mobile: String
    
    enum CodingKeys: String, CodingKey {
  //      case id = "id"
        case title = "title"
  //      case address = "address"
        case lat = "lat"
        case lng = "lng"
 //       case mobile = "mobile"
        
    }
}


// {"id":"1567","title":"R.NAIDU","address":"M.B.T. ROAD,PALAMANER,CHITTOOR,517408","lat":"13.03","lng":"80.2415","mobile":"7893632949"}
