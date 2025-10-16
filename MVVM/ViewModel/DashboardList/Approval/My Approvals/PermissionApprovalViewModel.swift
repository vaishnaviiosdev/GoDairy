//
//  PermissionApprovalViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 19/09/25.
//

import Foundation
import SwiftUI

@MainActor
class PermissionApprovalViewModel: ObservableObject {
    @Published var permissionApprovaldata: [PermissionApprovalModel] = []
    
    func fetchMissedApprovalData() async {
        do {
            let response: [PermissionApprovalModel] = try await NetworkManager.shared.fetchData(from: permissionApproval_Url, as: [PermissionApprovalModel].self
            )
            self.permissionApprovaldata = response
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
}
