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
    
//    func postPermissionSaveData(pdate: Date,
//                                startAt: String,
//                                endAt: String,
//                                reason: String,
//                                noOfHrs: String) async {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let pdateString = formatter.string(from: pdate)
//
//        let parameters: [String: Any] = [
//            "data": [
//                "PermissionEntry": [
//                    "pdate": pdateString,
//                    "start_at": startAt,
//                    "end_at": endAt,
//                    "Reason": reason,
//                    "No_of_Hrs": noOfHrs
//                ],
//                "Ekey": Ukey
//            ]
//        ]
//        
//        print("The parameters of the post permission save data is \(parameters)")
//
//        do {
//            let response: permissionSaveModel = try await NetworkManager.shared.postData(to: permission_saveUrl, parameters: parameters, as: permissionSaveModel.self)
//            self.permissionSaveResponse = response
//            print("The permission save response is \(response)")
//        }
//        catch {
//            print("Error fetching data is \(error.localizedDescription)")
//        }
//    }
    
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

        let parameters: [String: Any] = [
            "data": [
                [
                    "PermissionEntry": [
                        "pdate": pdateString,
                        "start_at": startAt,
                        "end_at": endAt,
                        "Reason": reason,
                        "No_of_Hrs": noOfHrs
                    ],
                    "Ekey": Ukey
                ]
            ]
        ]
        
        do {
            let response: permissionSaveModel = try await NetworkManager.shared.postData(
                to: permission_saveUrl,
                parameters: parameters,
                as: permissionSaveModel.self
            )
            self.permissionSaveResponse = response
            print("Permission save response: \(response)")
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
