//
//  LeaveApprovalHistoryViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 17/09/25.
//

import Foundation
import SwiftUI


@MainActor
class LeaveApprovalHistoryViewModel: ObservableObject {
    
    @Published var leaveApprovalHistoryList: [LeaveApprovalHistoryModel] = []
    
    
    func fetchLeaveHistoryData() async {
        do {
            let response: [LeaveApprovalHistoryModel] = try await NetworkManager.shared.fetchData(from: leaveApprovalHistory_Url, as: [LeaveApprovalHistoryModel].self
            )
            self.leaveApprovalHistoryList = response
            print("The Leave Approval History List is \(response)")
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
}
