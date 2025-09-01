//
//  LeaveRequestModel.swift
//  GoDairy
//
//  Created by San eforce on 28/08/25.
//

import Foundation
import SwiftUI

@MainActor
class LeaveRequestViewModel: ObservableObject {
    
    @Published var LeaveRequestData: [LeaveRequestDataResponse] = []
    @Published var LeaveShiftTimeData: [LeaveShiftTimeDataResponse] = []
    @Published var LeaveTypeData: [leaveTypeDataResponse] = []
    @Published var selectedLeaveCode: String? = nil
    @Published var shiftTimes: [String] = []
    
    func fetchLeaveAvailabilityData() async {
        do {
            let response: [LeaveRequestDataResponse] = try await NetworkManager.shared.fetchData(
                from: leaveAvailability_url,
                as: [LeaveRequestDataResponse].self
            )
            self.LeaveRequestData = response
            self.selectedLeaveCode = nil
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
    
    func fetchLeaveTypeData() async {
        
       // guard let url = URL(string: leaveTypes_url) else { return }
        
        let parameters: [String: Any] = [
            "data": ["tableName":"vwLeaveType",
                     "coloumns":"[\"id\",\"name\",\"Leave_Name\"]",
                     "orderBy":"[\"name asc\"]",
                     "desig":"mgr"]
            ]
        
        
        do {
            let response: [leaveTypeDataResponse] = try await NetworkManager.shared.postData(to: leaveTypes_url, parameters: parameters, as: [leaveTypeDataResponse].self)
            self.LeaveTypeData = response
            print("The leaveType Data is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func saveProducts(leave_Type: String, from_Date: String, to_Date: String, halfDay_Type: String) async {
        guard let url = URL(string: save_LeaveRequestUrl) else { return }

        let parameters: [String: Any] = [
            "LeaveFormValidate": [
                "Leave_Type": leave_Type,//
                "From_Date": from_Date,//
                "To_Date": to_Date,//
                "Shift": "",
                "PChk": 0,
                "HalfDay_Type": halfDay_Type,//
                "HalfDay": "0",//
                "Shift_Id": "",//
                "value": "",
                "Intime": "",
                "Outime": "",
                "NoofHrs": "",
                "EligDys": "",//
                "Ukey": "EKMGR80994092445"//
            ]
        ]
        
        //String(format: "EK%@-%i", SFCode,Int(Date().timeIntervalSince1970))

        do {
            let response: leaveSavedResponse = try await NetworkManager.shared.postData(to: url.absoluteString, parameters: parameters, as: leaveSavedResponse.self)
            print(response)
        }
        catch {
            print("Failed to post data: \(error)")
        }
    }
}

