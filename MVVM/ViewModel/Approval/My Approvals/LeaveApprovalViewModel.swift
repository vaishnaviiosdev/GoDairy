//
//  LeaveApprovalViewModel.swift
//  GoDairy
//
//  Created by San eforce on 17/09/25.
//

import Foundation
import SwiftUI

@MainActor
class LeaveApprovalViewModel: ObservableObject {
    
    @Published var leaveApprovalData: [leaveApprovalDataResponse] = []
    @Published var leaveApproveSubmit: leaveApprovalApprovalData?
    @Published var leaveRejectSubmit: leaveApprovalRejectData?
    @Published var showLeaveApprovedSaveAlert = false
    @Published var leaveApprovedSuccessMsg: String = ""
    @Published var showLeaveRejectSaveAlert = false
    @Published var leaveRejectSuccessMsg: String = ""
    
    func fetchLeaveApprovalData() async {
        do {
            let response: [leaveApprovalDataResponse] = try await NetworkManager.shared.fetchData(from: leaveApproval_Url, as: [leaveApprovalDataResponse].self
            )
            self.leaveApprovalData = response
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
    func PostLeaveApprovedData(FromDate: String, ToDate: String, no_ofDays: String, leave_Id: Int) async {
        let leaveApproval_ApprovalUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&Ukey=\(Ukey)&To_Date=:\(ToDate)&axn=dcr/save&Sf_Code=\(sf_code)&From_Date=:\(FromDate)&No_of_Days=:\(no_ofDays)&sfCode=\(sf_code)&leaveid=\(leave_Id)"
        
        print("The LeaveId is \(leave_Id)")
        
        let leaveApprovalEntry: [String: Any] = [
            "Sf_Code": sf_code
        ]

        // ✅ Wrap into array and `data`
        let orderedPayload: [[String: Any]] = [
            ["LeaveApproval": leaveApprovalEntry]
        ]

        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: leaveApprovalApprovalData = try await NetworkManager.shared.postFormData(urlString: leaveApproval_ApprovalUrl, parameters: parameters, responseType: leaveApprovalApprovalData.self
            )
            
            DispatchQueue.main.async {
                self.leaveApproveSubmit = response
                self.leaveApprovedSuccessMsg = "Leave Approved Successfully"
                self.showLeaveApprovedSaveAlert = true
            }
            print("✅ WeekOff Response: \(response)")
        }
        catch {
            self.leaveApprovedSuccessMsg = "Something went wrong.Try again"
            self.showLeaveApprovedSaveAlert = true
            print("Error fetching Data is \(error)")
        }
    }
    
    func PostLeaveRejectData(FromDate: String, ToDate: String, no_ofDays: String, leave_Id: Int, reason: String) async {
        let leaveApproval_RejectUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&Ukey=\(Ukey)&To_Date=:\(ToDate)&axn=dcr/save&Sf_Code=\(sf_code)&From_Date=:\(FromDate)&No_of_Days=:\(no_ofDays)&sfCode=\(sf_code)&leaveid=\(leave_Id)"
        
        print("The LeaveId is \(leave_Id)")
        
        let leaveRejectedEntry: [String: Any] = [
            "Sf_Code": sf_code,
            "reason" : reason
        ]

        // ✅ Wrap into array and `data`
        let orderedPayload: [[String: Any]] = [
            ["LeaveReject": leaveRejectedEntry]
        ]

        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: leaveApprovalRejectData = try await NetworkManager.shared.postFormData(urlString: leaveApproval_RejectUrl, parameters: parameters, responseType: leaveApprovalRejectData.self
            )
            
            DispatchQueue.main.async {
                self.leaveRejectSubmit = response
                self.leaveRejectSuccessMsg = "Leave Rejected Successfully"
                self.showLeaveRejectSaveAlert = true
            }
            print("✅ WeekOff Response: \(response)")
        }
        catch {
            self.leaveRejectSuccessMsg = "Something went wrong.Try again"
            self.showLeaveRejectSaveAlert = true
            print("Error fetching Data is \(error)")
        }
    }
}
