//
//  MissedApprovalViewModel.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import Foundation
import SwiftUI

@MainActor
class MissedApprovalViewModel: ObservableObject {
    @Published var MissedApprovaldata: [missedApprovalDataResponse] = []
    @Published var missedApproveSubmit: missedApprovalApprovalData?
    @Published var missedRejectSubmit: missedApprovalRejectData?
    @Published var showmissedApprovedSaveAlert = false
    @Published var missedApprovedSuccessMsg: String = ""
    @Published var showmissedRejectSaveAlert = false
    @Published var missedRejectSuccessMsg: String = ""
    
    func fetchMissedApprovalData() async {
        do {
            let response: [missedApprovalDataResponse] = try await NetworkManager.shared.fetchData(from: missedPunchApproval_Url, as: [missedApprovalDataResponse].self
            )
            self.MissedApprovaldata = response
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
    
    func PostmissedApprovedData(missedID: Int) async {
        let missedApproval_ApprovalUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&Ukey=\(Ukey)&axn=dcr/save&Missed_Id=\(missedID)&Sf_Code=\(sf_code)&sfCode=\(sf_code)"
        
        print("The missedId is \(missedID)")
        
        let missedApprovalEntry: [String: Any] = [
            "Sf_Code": sf_code        ]

        // ✅ Wrap into array and `data`
        let orderedPayload: [[String: Any]] = [
            ["MissedApproval": missedApprovalEntry]
        ]

        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: missedApprovalApprovalData = try await NetworkManager.shared.postFormData(urlString: missedApproval_ApprovalUrl, parameters: parameters, responseType: missedApprovalApprovalData.self
            )
            
            DispatchQueue.main.async {
                self.missedApproveSubmit = response
                self.missedApprovedSuccessMsg = "Missed Punch Approved Successfully"
                self.showmissedApprovedSaveAlert = true
            }
            print("✅ WeekOff Response: \(response)")
        }
        catch {
            self.missedApprovedSuccessMsg = "Something went wrong.Try again"
            self.showmissedApprovedSaveAlert = true
            print("Error fetching Data is \(error)")
        }
    }
    
    func PostmissedRejectData(missedID: Int, reason: String) async {
        let missedApproval_RejectUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&Ukey=\(Ukey)&axn=dcr/save&Missed_Id=\(missedID)&Sf_Code=\(sf_code)&sfCode=\(sf_code)"
        
        let missedRejectedEntry: [String: Any] = [
            "Sf_Code": sf_code,
            "reason" : reason
        ]

        let orderedPayload: [[String: Any]] = [
            ["MissedApprovalR": missedRejectedEntry]
        ]

        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: missedApprovalRejectData = try await NetworkManager.shared.postFormData(urlString: missedApproval_RejectUrl, parameters: parameters, responseType: missedApprovalRejectData.self
            )
            
            DispatchQueue.main.async {
                self.missedRejectSubmit = response
                self.missedRejectSuccessMsg = "Missed Punch Rejected Successfully"
                self.showmissedRejectSaveAlert = true
            }
            print("✅ WeekOff Response: \(response)")
        }
        catch {
            self.missedRejectSuccessMsg = "Something went wrong.Try again"
            self.showmissedRejectSaveAlert = true
            print("Error fetching Data is \(error)")
        }
    }

}
