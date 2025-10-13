//
//  GeoTaggingViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 07/10/25.
//

import Foundation
import SwiftUI


@MainActor
class GeoTaggingViewModel: ObservableObject {
    
   // @Published var geoTaggingModelData: [GeoTaggingModelResponse] = []
    
    @Published var geoTaggingModelData: GeoTaggingModelResponse?

    func fetchGeoTaggingData() async {
        do {
            let response: GeoTaggingModelResponse = try await NetworkManager.shared.fetchData(from: geoTagging_Url, as: GeoTaggingModelResponse.self
            )
            print(response)
            self.geoTaggingModelData = response
            
        }catch {
            print("Error Fetching data is \(error)")
        }
    }
    
}
