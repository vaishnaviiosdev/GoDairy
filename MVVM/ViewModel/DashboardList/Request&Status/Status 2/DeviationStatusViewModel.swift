//
//  DeviationStatusViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 24/09/25.
//

import Foundation
import SwiftUI


@MainActor
class DeviationStatusViewModel: ObservableObject {
    
    @Published var deviationStatusData: [DeviationStatusModel] = []
    
    func fetchDeviationStatus() async {
        do {
            let response: [DeviationStatusModel] = try await NetworkManager.shared.fetchData(from: deviationStatus_Url, as: [DeviationStatusModel].self
            )
            self.deviationStatusData = response
            print("The FetchLeaveStatusData is : \(response)")
        }
        catch {
            print("Error fetching Data is \(error)")
        }
    }
}
