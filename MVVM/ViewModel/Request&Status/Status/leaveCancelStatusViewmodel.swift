//
//  leaveCancelViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 08/09/25.
//

import Foundation
import SwiftUI

@MainActor
class leaveCancelViewModel: ObservableObject {
    
    @Published var leaveCancelData : [leaveCancelDataResponse] = []
    
    func fetchLeaveCancelData() async {
        do {
            let response: [leaveCancelDataResponse] = try await NetworkManager.shared.fetchData(from: leaveCancelStatus_Url, as: [leaveCancelDataResponse].self
            )
            self.leaveCancelData = response
            print("The leaveCancelDataResponse response is \(response)")
        }
        catch {
            print("Error fetching data is \(error)")
        }
    }
}
