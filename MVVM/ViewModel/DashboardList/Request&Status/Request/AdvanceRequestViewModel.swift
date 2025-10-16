//
//  AdvanceRequest.swift
//  GoDairy
//
//  Created by San eforce on 01/09/25.
//

import Foundation
import SwiftUI

@MainActor
class AdvanceRequestViewModel: ObservableObject {
    
    @Published var advanceRequestData : [advanceRequestModelData] = []
    @Published var advanceSaveData : [advanceRequestSaveData] = []
    @Published var showSaveSuccessAlert = false
    @Published var saveSuccessMessage: String = ""
    @Published var advanceTypes: [String] = []
    
    func fetchAdvanceTypeData() async {
        do {
            let response: [advanceRequestModelData] = try await NetworkManager.shared.fetchData(from: advanceType_url, as: [advanceRequestModelData].self)
            self.advanceRequestData = response
            await MainActor.run {
                self.advanceTypes = response.map { $0.name }
            }
            print("Advance Types: \(self.advanceTypes)")
            print("The advanceRequestData response is \(response)")
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func PostAdvanceRequestData(
        Ukey: String,
        SF: String,
        eDate: String,
        advFrom: String,
        advTo: String,
        advTyp: String,
        advLoc: String,
        advPurp: String,
        advAmt: String,
        advSettle: String
    ) async {
        let parameters: [String: Any] = [
            "data": [
                "Ukey": Ukey,
                "SF": SF,
                "eDate": eDate,
                "AdvFrom": advFrom,
                "AdvTo": advTo,
                "AdvTyp": advTyp,
                "AdvLoc": advLoc,
                "AdvPurp": advPurp,
                "AdvAmt": advAmt,
                "AdvSettle": advSettle
            ]
        ]
        
        print("The Save Advance Request parameters are \(parameters)")

        do {
            let response: [advanceRequestSaveData] = try await NetworkManager.shared.postData(
                to: save_AdvanceRequestUrl,
                parameters: parameters,
                as: [advanceRequestSaveData].self
            )
            self.advanceSaveData = response
            saveSuccessMessage = response[0].Msg
            showSaveSuccessAlert = true
            print("The advance request save data is \(response)")
            print("The advance Save Data is \(self.advanceSaveData.count)")
        }
        catch {
            saveSuccessMessage = "Please try again later"
            showSaveSuccessAlert = true
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
}
