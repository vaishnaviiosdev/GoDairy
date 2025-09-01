//
//  AdvanceRequest.swift
//  GoDairy
//
//  Created by San eforce on 01/09/25.
//

import Foundation
import SwiftUI

@MainActor
class AdvanceRequestViewModel: ObservableObject {
    
    @Published var advanceRequestData : [advanceRequestModelData] = []
    @Published var advanceTypes: [String] = []
    
    func fetchAdvanceTypeData() async {
        do {
            let response: [advanceRequestModelData] = try await NetworkManager.shared.fetchData(from: advanceType_url, as: [advanceRequestModelData].self)
            self.advanceRequestData = response
            await MainActor.run {
                self.advanceTypes = response.map { $0.name }
            }
            print("Advance Types: \(self.advanceTypes)")
            print("The advanceRequestData response is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
}
