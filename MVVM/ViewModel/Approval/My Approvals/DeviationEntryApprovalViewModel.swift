//
//  DeviationEntryApprovalViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 23/09/25.
//

import Foundation
import SwiftUI


@MainActor
class DeviationEntryApprovalViewModel: ObservableObject {
    @Published var deviationEntryApprovaldata: [DeviationEntryApprovalModel] = []
    @Published var showDeviationApprovedSaveAlert = false
    @Published var deviationApprovedSuccessMsg: String = ""
    @Published var showDeviationRejectSaveAlert = false
    @Published var deviationRejectSuccessMsg: String = ""
    
    func fetchDeviationEntryApprovalData() async {
        do {
            let response: [DeviationEntryApprovalModel] = try await NetworkManager.shared.fetchData(from: deviationApproval_Url, as: [DeviationEntryApprovalModel].self
            )
            self.deviationEntryApprovaldata = response
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
    
    func saveDeviationApproval(sfCode: String, deviationId: Int) async {
        let deviationApprovalUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&axn=dcr/save&Sf_Code=\(sfCode)&sfCode=\(sf_code)&deviationid=\(deviationId)"
        
        print("The LeaveId is \(deviationId)")
        
        let deviationApprovalEntry: [String: Any] = [
            "Sf_Code": sfCode
        ]
        let orderedPayload: [[String: Any]] = [
            ["DeviationApproval": deviationApprovalEntry]
        ]

        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: leaveApprovalApprovalData = try await NetworkManager.shared.postFormData(urlString: deviationApprovalUrl, parameters: parameters, responseType: leaveApprovalApprovalData.self
            )
            
            DispatchQueue.main.async {
                self.deviationApprovedSuccessMsg = "Deviation Approved Successfully"
                self.showDeviationApprovedSaveAlert = true
            }
            print(response)
        }
        catch {
            self.deviationApprovedSuccessMsg = "Something went wrong.Try again"
            self.showDeviationApprovedSaveAlert = true
            print("Error fetching Data is \(error)")
        }
    }
    
    func saveDeviationReject(sfCode: String, deviationId: Int, reason: String) async {
        let deviationApprovalUrl = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "State_Code=1&desig=MGR&divisionCode=\(division_code)&axn=dcr/save&Sf_Code=\(sfCode)&sfCode=\(sf_code)&deviationid=\(deviationId)"
        
        
        let leaveRejectedEntry: [String: Any] = [
            "Sf_Code": sfCode,
            "reason" : reason
        ]
        
        let orderedPayload: [[String: Any]] = [
            ["DeviationReject": leaveRejectedEntry]
        ]

        let parameters: [String: Any] = [
            "data": orderedPayload
        ]
        
        do {
            let response: leaveApprovalRejectData = try await NetworkManager.shared.postFormData(urlString: deviationApprovalUrl, parameters: parameters, responseType: leaveApprovalRejectData.self
            )
            
            DispatchQueue.main.async {
                self.deviationRejectSuccessMsg = "Deviation Rejected Successfully"
                self.showDeviationRejectSaveAlert = true
            }
            print(response)
        }
        catch {
            self.deviationRejectSuccessMsg = "Something went wrong.Try again"
            self.showDeviationRejectSaveAlert = true
            print("Error fetching Data is \(error)")
        }
    }
}
