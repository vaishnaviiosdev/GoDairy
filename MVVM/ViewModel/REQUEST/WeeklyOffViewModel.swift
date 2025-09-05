//
//  WeeklyOffViewModel.swift
//  GoDairy
//
//  Created by San eforce on 05/09/25.
//

import Foundation
import SwiftUI

@MainActor
class WeeklyOffViewModel: ObservableObject {
    
    @Published var weeklyOffDataResponse: WeekOffModelResponse?
    @Published var showWeeklyOffSaveAlert = false
    @Published var saveWeeklyOffSuccessMsg: String = ""
    
    func postWeekOffEntry(
        weekDate: Date,
        reason: String
    ) async {
        // ✅ Format Date (yyyy-M-d)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        let formattedDate = formatter.string(from: weekDate)
        
        // ✅ Build WeekofPunch payload
        let weekOffEntry: [String: Any] = [
            "Ukey": Ukey,
            "WKDate": formattedDate,
            "reason": reason
        ]
        
        // ✅ Wrap into array and `data`
        let orderedPayload: [[String: Any]] = [
            ["WeekofPunch": weekOffEntry]
        ]
        
        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: WeekOffModelResponse = try await NetworkManager.shared.postFormData(
                urlString: weekoffEntry_saveUrl,
                parameters: parameters,
                responseType: WeekOffModelResponse.self
            )
            
            DispatchQueue.main.async {
                self.weeklyOffDataResponse = response
                self.saveWeeklyOffSuccessMsg = response.Msg
                self.showWeeklyOffSaveAlert = true
            }
            print("✅ WeekOff Response: \(response)")
        }
        catch {
            DispatchQueue.main.async {
                self.saveWeeklyOffSuccessMsg = "Please try again later"
                self.showWeeklyOffSaveAlert = true
            }
            print("❌ Error: \(error.localizedDescription)")
        }
    }

    

    
}
