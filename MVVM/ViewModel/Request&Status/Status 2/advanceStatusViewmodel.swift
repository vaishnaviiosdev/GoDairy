//
//  advanceStatusViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import Foundation
import SwiftUI

@MainActor
class advancestatusviewmodel: ObservableObject {
    
    @Published var advanceStatusDataResponse: [advStatusDataResponse] = []
    
    func fetchAdvanceStatusData() async {
        do {
            let response: [advStatusDataResponse] = try await NetworkManager.shared.fetchData(from: advanceStatus_Url, as: [advStatusDataResponse].self
            )
            self.advanceStatusDataResponse = response
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
}
