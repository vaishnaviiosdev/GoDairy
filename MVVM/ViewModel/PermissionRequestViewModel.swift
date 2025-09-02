//
//  PermissionRequestViewModel.swift
//  GoDairy
//
//  Created by San eforce on 02/09/25.
//

import Foundation
import SwiftUI

@MainActor
class PermissionRequestViewModel: ObservableObject {
    
    @Published var permissionRequestData : [PermissionRequestModel] = []
    @Published var permissionTypes: [String] = []
    
    func fetchPermissionShiftTimeData() async {
        do {
            let response: [PermissionRequestModel] = try await NetworkManager.shared.fetchData(from: permission_shiftTimeUrl, as: [PermissionRequestModel].self)
            self.permissionRequestData = response
            await MainActor.run {
                self.permissionTypes = response.map { $0.name }
            }
            print("Permission Types: \(self.permissionTypes.count)")
            print("The permissionRequestData response is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
}
