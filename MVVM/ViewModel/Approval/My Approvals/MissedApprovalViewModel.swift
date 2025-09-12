//
//  MissedApprovalViewModel.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import Foundation
import SwiftUI

@MainActor
class MissedApprovalViewModel: ObservableObject {
    @Published var MissedApprovaldata: [missedApprovalDataResponse] = []
    
    func fetchMissedApprovalData() async {
        do {
            let response: [missedApprovalDataResponse] = try await NetworkManager.shared.fetchData(from: missedPunchApproval_Url, as: [missedApprovalDataResponse].self
            )
            self.MissedApprovaldata = response
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
}
