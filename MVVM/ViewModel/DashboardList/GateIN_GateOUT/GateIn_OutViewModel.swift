//
//  GateInViewModel.swift
//  GoDairy
//
//  Created by San eforce on 16/10/25.
//

import SwiftUI
import Foundation

@MainActor
class GateIn_OutViewModel: ObservableObject {
    
    @Published var gateInData: GateInDataResponse?
    @Published var gateOutData: GateOUTDataResponse?
    @Published var gateInOutListData: [GateInOutListDataResponse] = []
    @Published var showGateSaveAlert = false
    @Published var saveGateSuccessMsg: String = ""
    
    func postGateData(
        type: String, // "GateIn" or "GateOut"
        hdloc: String,
        hqLocId: String,
        location: String,
        majourType: String,
        latLng: String,
        mode: String
    ) async {
        
        let payload: [String: Any] = [
            "HQLoc": hdloc,
            "HQLocID": hqLocId,
            "Location": location,
            "MajourType": majourType,
            "latLng": latLng,
            "mode": mode,
            "time": Date().formattedAsYYYYMMDD(),
            "eDate": dateTime.eDate,
            "eTime": dateTime.eTime
        ]
        
        let wrappedData: [String: Any] = [
            type: payload
        ]
        
        let parameters: [String: Any] = [
            "data": [wrappedData]
        ]
        
        do {
            if type == "GateIn" {
                let response: GateInDataResponse = try await NetworkManager.shared.postFormData(
                    urlString: Gate_Url,
                    parameters: parameters,
                    responseType: GateInDataResponse.self
                )
                DispatchQueue.main.async {
                    self.gateInData = response
                    self.saveGateSuccessMsg = response.Msg ?? "Success"
                    self.showGateSaveAlert = true
                }
            }
            else {
                let response: GateOUTDataResponse = try await NetworkManager.shared.postFormData(
                    urlString: Gate_Url,
                    parameters: parameters,
                    responseType: GateOUTDataResponse.self
                )
                DispatchQueue.main.async {
                    self.gateOutData = response
                    self.saveGateSuccessMsg = response.Msg ?? "Success"
                    self.showGateSaveAlert = true
                }
            }
        }
        catch {
            DispatchQueue.main.async {
                self.saveGateSuccessMsg = error.localizedDescription
                self.showGateSaveAlert = true
            }
            print("❌ Error posting gate data: \(error)")
        }
    }
    
    func fetchgateInOutListData() async {
        do {
            let response : [GateInOutListDataResponse] = try await NetworkManager.shared.fetchData(from: GateInOutList_Url, as: [GateInOutListDataResponse].self
            )
            self.gateInOutListData = response
        }
        catch {
            print("Error Fetching data is \(error.localizedDescription)")
        }
    }
}

