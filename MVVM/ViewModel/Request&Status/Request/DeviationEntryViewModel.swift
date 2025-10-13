//
//  DeviationEntryViewModel.swift
//  GoDairy
//
//  Created by San eforce on 05/09/25.
//

import Foundation
import SwiftUI

@MainActor
class DeviationEntryViewModel: ObservableObject {
    
    @Published var DeviationEntryModel : [DeviationEntryDataResponse] = []
    @Published var DeviationEntryName: [String] = []
    
    func postDeviationTypeRequest() async {
        let parameters: [String: Any] = [
            "data": [
                "tableName": "vwdeviationtype",
                "coloumns": "[\"id\",\"name\",\"Leave_Name\"]",
                "orderBy": "[\"name asc\"]",
                "desig": "mgr"
            ]
        ]

        do {
            let response: [DeviationEntryDataResponse] = try await NetworkManager.shared.postFormData(
                urlString: DeviationEntry_Url, // <-- replace with your API URL
                parameters: parameters,
                responseType: [DeviationEntryDataResponse].self
            )
            self.DeviationEntryModel = response
            
            await MainActor.run {
                self.DeviationEntryName = response.map { $0.name }
            }
            print("✅ Deviation Type Response: \(response)")
        }
        catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}
