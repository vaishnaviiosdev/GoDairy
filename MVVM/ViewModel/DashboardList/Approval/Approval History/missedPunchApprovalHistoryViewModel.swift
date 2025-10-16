//
//  missedPunchApprovalViewModel.swift
//  GoDairy
//
//  Created by San eforce on 16/09/25.
//

import Foundation
import SwiftUI

@MainActor
class missedPunchApprovalHistoryViewModel: ObservableObject {
    
    @Published var MP_ApprovalHistoryData: [approvalMissedPunchModel] = []
    
    func fetchMissedPunchHistorydata() async {
        do {
            let response: [approvalMissedPunchModel] = try await NetworkManager.shared.fetchData(from: missedPunchHistoryApproval_Url, as: [approvalMissedPunchModel].self
            )
            self.MP_ApprovalHistoryData = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
}
