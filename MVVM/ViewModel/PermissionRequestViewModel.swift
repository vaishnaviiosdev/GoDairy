//
//  PermissionRequestViewModel.swift
//  GoDairy
//
//  Created by San eforce on 02/09/25.
//

import Foundation
import SwiftUI

@MainActor
class PermissionRequestViewModel: ObservableObject {
    
    @Published var permissionRequestData : [PermissionRequestModel] = []
    @Published var permissionTypes: [String] = []
    @Published var permissionHrsModel : [permissionTakenHrsModel] = []
    @Published var permissionSaveResponse : permissionSaveModel?
    @Published var showPermissionSaveAlert = false
    @Published var savePermissionSuccessMsg: String = ""
    
    func fetchPermissionShiftTimeData() async {
        do {
            let response: [PermissionRequestModel] = try await NetworkManager.shared.fetchData(from: permission_shiftTimeUrl, as: [PermissionRequestModel].self)
            self.permissionRequestData = response
            await MainActor.run {
                self.permissionTypes = response.map { $0.name }
            }
            print("Permission Types: \(self.permissionTypes.count)")
            print("The permissionRequestData response is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
        
    func fetchTakenHrsData() async {
        let parameters: [String: Any] = [
            "orderBy": "[\"name asc\"]",
            "desig": "mgr"
        ]
        print("The parameters is \(parameters)")
        
        do {
            let response: [permissionTakenHrsModel] = try await NetworkManager.shared.postData(
                to: permission_takenHrsUrl,
                parameters: parameters,
                as: [permissionTakenHrsModel].self
            )
            self.permissionHrsModel = response
            print("The permissionTakenHours response is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func postPermissionSaveData(
            pdate: Date,
            startAt: String,
            endAt: String,
            reason: String,
            noOfHrs: String
        ) async {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let pdateString = formatter.string(from: pdate)

            // Build PermissionEntry object
            let permissionEntry: [String: Any] = [
                "pdate": pdateString,
                "start_at": startAt,
                "end_at": endAt,
                "Reason": reason,
                "No_of_Hrs": noOfHrs
            ]

            // Ensure key order: PermissionEntry first, then Ekey
            let orderedPayload: [[String: Any]] = [
                [
                    "PermissionEntry": permissionEntry,
                    "Ekey": Ukey
                ]
            ]

            let parameters: [String: Any] = [
                "data": orderedPayload
            ]

            do {
                let response: permissionSaveModel = try await NetworkManager.shared.postFormData(
                    urlString: permission_saveUrl,
                    parameters: parameters,
                    responseType: permissionSaveModel.self
                )

                self.permissionSaveResponse = response
                self.savePermissionSuccessMsg = response.Msg
                self.showPermissionSaveAlert = true
                print("✅ Permission Saved Response: \(response)")
            }
            catch {
                self.savePermissionSuccessMsg = "Please try again later"
                self.showPermissionSaveAlert = true
                print("❌ Error: \(error.localizedDescription)")
            }
        }
            
    
//        func postPermissionSaveData(
//            pdate: Date,
//            startAt: String,
//            endAt: String,
//            reason: String,
//            noOfHrs: String
//        ) async {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let pdateString = formatter.string(from: pdate)
//    
//            let payloadArray: [[String: Any]] = [
//                [
//                    "PermissionEntry": [
//                        "pdate": pdateString,
//                        "start_at": startAt,
//                        "end_at": endAt,
//                        "Reason": reason,
//                        "No_of_Hrs": noOfHrs
//                    ],
//                    "Ekey": Ukey
//                ]
//            ]
//    
//            guard let jsonData = try? JSONSerialization.data(withJSONObject: payloadArray, options: []),
//                  let jsonString = String(data: jsonData, encoding: .utf8) else {
//                print("Failed to encode JSON")
//                return
//            }
//    
//            // Create form-data body
//            let bodyString = "data=\(jsonString)"
//            guard let bodyData = bodyString.data(using: .utf8) else { return }
//    
//            // Build request
//            guard let url = URL(string: permission_saveUrl) else { return }
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.httpBody = bodyData
//    
//            print("Form-Data Body: \(bodyString)")
//    
//            do {
//                let (data, response) = try await URLSession.shared.data(for: request)
//                if let json = String(data: data, encoding: .utf8) {
//                    print("Response: \(json)")
//                }
//            }
//            catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
}
