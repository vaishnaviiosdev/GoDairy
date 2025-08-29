//
//  LeaveRequestModel.swift
//  GoDairy
//
//  Created by San eforce on 28/08/25.
//

import Foundation
import SwiftUI

@MainActor
class LeaveRequestModel: ObservableObject {
    
    @Published var LeaveRequestData: [LeaveRequestDataResponse] = []
    
    func fetchLeaveRequestData() async {
        do {
            let response: [LeaveRequestDataResponse] = try await NetworkManager.shared.fetchData(
                from: leaveAvailability_url,
                as: [LeaveRequestDataResponse].self
            )
            DispatchQueue.main.async {
                self.LeaveRequestData = response
                print("Response: \(self.LeaveRequestData[0].LeaveAvailability)")
            }
            //self.LeaveRequestData = response  // ✅ safely updates on main thread
           
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
}

