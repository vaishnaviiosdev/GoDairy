//
//  ViewModel.swift
//  GoDairy
//
//  Created by San eforce on 18/08/25.
//

import Foundation
import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    @Published var data: [fetchResponse] = []
    @Published var mydayplanData: [mydayplanworkTypeResponse] = []
    
    func fetchData() async {
        do {
            let response: [fetchResponse] = try await NetworkManager.shared.fetchData(
                from: milk_url,
                as: [fetchResponse].self
            )
            self.data = response 
            print("Response: \(response)")
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
}

