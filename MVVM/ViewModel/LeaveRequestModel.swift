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
    @Published var LeaveShiftTimeData: [LeaveShiftTimeDataResponse] = []
    @Published var shiftTimes: [String] = []
    
    func fetchLeaveAvailabilityData() async {
        do {
            let response: [LeaveRequestDataResponse] = try await NetworkManager.shared.fetchData(
                from: leaveAvailability_url,
                as: [LeaveRequestDataResponse].self
            )
            self.LeaveRequestData = response  
            print("Response: \(self.LeaveRequestData)")
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func fetchShiftTimeData() async {
        do {
            let response: [LeaveShiftTimeDataResponse] = try await NetworkManager.shared.fetchData(from: shiftTime_url, as: [LeaveShiftTimeDataResponse].self
            )
            
            self.LeaveShiftTimeData = response
            
            await MainActor.run {
                self.shiftTimes = response.map { $0.name }
            }
            print("Shift Times: \(self.shiftTimes)")
            print("Response: \(self.LeaveShiftTimeData)")
        }
        catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    
}

