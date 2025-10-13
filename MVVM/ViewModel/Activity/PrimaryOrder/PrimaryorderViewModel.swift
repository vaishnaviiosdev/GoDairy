
//
//  primaryorderviewmodel.swift
//  GoDairy
//
//  Created by San eforce on 10/10/25.
//

import Foundation
import SwiftUI

@MainActor
class PrimaryorderViewModel: ObservableObject {
    
    @Published var primaryOrderDataResponse: [primaryOrderData] = []
    
    func fetchPrimaryOrderData() async {
        let workTypePayload: [String: Any] = [
            "SF": sf_code,
            "div": division_code
        ]
        
        let parameters: [String: Any] = [
            "data": workTypePayload
        ]
        
        do {
            let response: [primaryOrderData] = try await NetworkManager.shared.postFormData(urlString: primary_OrderUrl, parameters: parameters, responseType: [primaryOrderData].self
            )
            self.primaryOrderDataResponse = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
}
