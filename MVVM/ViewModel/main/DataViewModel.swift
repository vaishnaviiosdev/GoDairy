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
    @Published var mydayplanData: [mydayplanDataResponse] = []
    
    func fetchData() async {
        do {
            let response: [fetchResponse] = try await NetworkManager.shared.fetchData(
                from: milk_url,
                as: [fetchResponse].self
            )
            self.data = response   // ✅ safely updates on main thread
            print("Response: \(response)")
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func getWorkTypesData(sf: String, div: String) async {
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/worktypes"
        guard let url = URL(string: urlString) else { return }
        
        let body: [String: Any] = [
            "data": [
                "SF": sf,
                "div": div
            ]
        ]
        
        do {
            let response: [mydayplanDataResponse] = try await NetworkManager.shared.postData(to: url.absoluteString, parameters: body, as: [mydayplanDataResponse].self)
            print("The getworkTypesData response is \(response) and \(body)")
        }
        catch {
            print("Failed to get work Types Data")
        }
    }
}

