//
//  AdvanceApprovalHistoryViewModel.swift
//  GoDairy
//
//  Created by Naga Prasath on 18/09/25.
//

import Foundation


@MainActor
class AdvanceApprovalHistoryViewModel : ObservableObject {
    
    @Published var advanceApprovalHistoryList : [AdvanceApprovalHistoryModel] = []
    
    func fetchAdevanceHistoryData() async {
        do {
            let response: [AdvanceApprovalHistoryModel] = try await NetworkManager.shared.fetchData(from: advanceApprovalHistory_Url, as: [AdvanceApprovalHistoryModel].self
            )
            self.advanceApprovalHistoryList = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
}
