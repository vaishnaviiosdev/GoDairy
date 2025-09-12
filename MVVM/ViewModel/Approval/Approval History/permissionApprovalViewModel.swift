//
//  permissionApprovalViewModel.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import Foundation
import SwiftUI

@MainActor
class permissionApprovalViewModel: ObservableObject {
    
    @Published var permissionApprovalData: [approvalPermissionDataResponse] = []
    
    func fetchapprovalPermissionData() async {
        do {
            let response: [approvalPermissionDataResponse] = try await NetworkManager.shared.fetchData(from: permissionHistoryApproval_Url, as: [approvalPermissionDataResponse].self
            )
            self.permissionApprovalData = response
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
}
