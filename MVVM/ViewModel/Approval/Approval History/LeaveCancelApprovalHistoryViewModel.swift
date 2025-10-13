//
//  LeaveCancelHistoryViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 23/09/25.
//

import Foundation
import SwiftUI


@MainActor
class LeaveCancelHistoryViewModel: ObservableObject {
    
    @Published var leaveCancelApprovalHistoryList: [LeaveCancelApprovalHistoryModel] = []
    
    
    func fetchLeaveCancelHistoryData() async {
        do {
            let response: [LeaveCancelApprovalHistoryModel] = try await NetworkManager.shared.fetchData(from: leaveCancelApprovalHistory_Url, as: [LeaveCancelApprovalHistoryModel].self
            )
            self.leaveCancelApprovalHistoryList = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
}
