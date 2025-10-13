//
//  MissedPunchViewModel.swift
//  GoDairy
//
//  Created by San eforce on 04/09/25.
//

import Foundation
import SwiftUI

@MainActor
class MissedPunchViewModel: ObservableObject {
    @Published var missedPunchResponse : [MissedPunchDataResponse] = []
    @Published var missedTypes: [String] = []
    @Published var missedPunchSaveData : missedPunchSaveResponse?
    @Published var showMissedPunchSaveAlert = false
    @Published var saveMissedPunchSuccessMsg: String = ""
    
    func fetchMissedPunchData() async {
        do {
            let response: [MissedPunchDataResponse] = try await NetworkManager.shared.fetchData(from: missedPunchUrl, as: [MissedPunchDataResponse].self)
            self.missedPunchResponse = response
            await MainActor.run {
                self.missedTypes = response.map { $0.name1 } //cleanBrackets(from: $0.name1) 
            }
            print("The MissedPunchTypes is \(self.missedTypes)")
            print("The MissedPunchRequestData response is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func postMissedPunchEntry(
        missedDate: String,
        shiftName: String,
        checkoutTime: String,
        checkinTime: String,
        reason: String
    ) async {

        let missedPunchEntry: [String: Any] = [
            "Ukey": Ukey,
            "missed_date": missedDate,
            "Shift_Name": shiftName,
            "checkouttime": checkoutTime,
            "checkinTime": checkinTime,
            "reason": reason,
            "km": "",
            "pkm": 0,
            "mod": "",
            "sf": "",
            "div": "",
            "url": "",
            "from": "",
            "to": "",
            "to_code": "",
            "fare": "",
            "aflag": ""
        ]
        
        let orderedPayload: [[String: Any]] = [
            ["MissedPunchEntry": missedPunchEntry]
        ]
        
        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: missedPunchSaveResponse = try await NetworkManager.shared.postFormData(
                urlString: missedPunch_SaveUrl,
                parameters: parameters,
                responseType: missedPunchSaveResponse.self
            )
            
            DispatchQueue.main.async {
                self.missedPunchSaveData = response
                self.saveMissedPunchSuccessMsg = response.Msg
                self.showMissedPunchSaveAlert = true
            }
            print("✅ Missed Punch Response: \(response)")
        }
        catch {
            DispatchQueue.main.async {
                self.saveMissedPunchSuccessMsg = "Please try again later"
                self.showMissedPunchSaveAlert = true
            }
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}
