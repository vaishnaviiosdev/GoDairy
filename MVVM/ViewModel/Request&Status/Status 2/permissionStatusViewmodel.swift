//
//  permissionStatusViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import Foundation
import SwiftUI

@MainActor
class permissionStatusViewmodel: ObservableObject {
    @Published var permissionStatusData: [permissionDataResponse] = []
    
    func fetchPermissionData() async {
        do {
            let response: [permissionDataResponse] = try await NetworkManager.shared.fetchData(from: permissionStatus_Url, as: [permissionDataResponse].self
            )
            self.permissionStatusData = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
}
