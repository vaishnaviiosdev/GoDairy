//
//  missedPunchStatusViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import Foundation
import SwiftUI

@MainActor
class missedPunchViewModel: ObservableObject {
    
    @Published var missedPunchData: [missedPunchModel] = []
    
    func fetchMissedPunchData() async {
        do {
            let response: [missedPunchModel] = try await NetworkManager.shared.fetchData(from: missedPunch_Url, as: [missedPunchModel].self
            )
            self.missedPunchData = response
            print("The Missed Punch Data Response is \(response)")
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
}
