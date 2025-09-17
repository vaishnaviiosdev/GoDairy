//
//  LeaveApprovalViewModel.swift
//  GoDairy
//
//  Created by San eforce on 17/09/25.
//

import Foundation
import SwiftUI

@MainActor
class LeaveApprovalViewModel: ObservableObject {
    
    @Published var leaveApprovalData: [leaveApprovalDataResponse] = []
    
    func fetchLeaveApprovalData() async {
        do {
            let response: [leaveApprovalDataResponse] = try await NetworkManager.shared.fetchData(from: leaveApproval_Url, as: [leaveApprovalDataResponse].self
            )
            self.leaveApprovalData = response
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
}
