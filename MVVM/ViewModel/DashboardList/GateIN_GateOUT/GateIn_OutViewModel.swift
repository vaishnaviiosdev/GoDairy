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
    @Published var showGateSaveAlert = false
    @Published var saveGateSuccessMsg: String = ""
    
    func PostGateInData(hdloc: String, hqLocId: String, location: String, majourType: String, latLng: String, mode: String) async {
        
        let gateInPayload: [String: Any] = [
            "HQLoc" : hdloc,
            "HQLocID" : hqLocId,
            "Location" : location,
            "MajourType" : majourType,
            "latLng" : latLng,
            "mode" : mode,
            "time" : Date().formattedAsYYYYMMDD(),
            "eDate" : dateTime.eDate,
            "eTime" : dateTime.eTime
        ]
        
        let gateInData : [String: Any] = [
            "GateIn" : gateInPayload
        ]
        
        let parameters: [String: Any] = [
            "data" : [gateInData]
        ]
        
        do {
            let response: GateInDataResponse = try await NetworkManager.shared.postFormData(urlString: Gate_Url, parameters: parameters, responseType: GateInDataResponse.self
            )
            DispatchQueue.main.async {
                self.gateInData = response
                self.saveGateSuccessMsg = response.Msg ?? "Success"
                self.showGateSaveAlert = true
            }
        }
        catch {
            DispatchQueue.main.async {
                self.saveGateSuccessMsg = error.localizedDescription
                self.showGateSaveAlert = true
            }
            print("Error Fetching data is \(error)")
        }
    }
    
    func PostGateOUTData(hdloc: String, hqLocId: String, location: String, majourType: String, latLng: String, mode: String) async {
        
        let gateOutPayload: [String: Any] = [
            "HQLoc" : hdloc,
            "HQLocID" : hqLocId,
            "Location" : location,
            "MajourType" : majourType,
            "latLng" : latLng,
            "mode" : mode,
            "time" : Date().formattedAsYYYYMMDD(),
            "eDate" : dateTime.eDate,
            "eTime" : dateTime.eTime
        ]
        
        let gateOutData : [String: Any] = [
            "GateOut" : gateOutPayload
        ]
        
        let parameters: [String: Any] = [
            "data" : [gateOutData]
        ]
        
        do {
            let response: GateOUTDataResponse = try await NetworkManager.shared.postFormData(urlString: Gate_Url, parameters: parameters, responseType: GateOUTDataResponse.self
            )
            self.gateOutData = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
    
}
