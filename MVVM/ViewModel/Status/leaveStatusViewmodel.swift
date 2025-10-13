//
//  leaveStatusViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 08/09/25.
//

import Foundation
import SwiftUI

@MainActor
class leaveStatusViewModel: ObservableObject {
    
    @Published var leaveStatusData: [leaveStatusModel] = []
    
    func fetchLeaveStatusData() async {
        do {
            let response: [leaveStatusModel] = try await NetworkManager.shared.fetchData(from: leaveStatus_Url, as: [leaveStatusModel].self
            )
            self.leaveStatusData = response
            print("The FetchLeaveStatusData is : \(response)")
        }
        catch {
            print("Error fetching Data is \(error)")
        }
    }
}
