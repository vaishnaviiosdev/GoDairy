//
//  weeklyoffViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 09/09/25.
//

import Foundation
import SwiftUI

@MainActor
class weeklyoffViewModel: ObservableObject {
    @Published var weeklyOffData: weekOffDataResponse?
    
    func fetchWeekOffData(startDate: Date, endDate: Date) async {
        do {
            let weeklyOffStatus_Url = APIClient.shared.New_DBUrl + "/server/MyPHP.php?&div=1&sf=MGR80&tvStartDate=\(startDate)&axn=get_week_off_status&tvEndDate=\(endDate)&sfCode=MGR80&stk="
            
            let response: weekOffDataResponse = try await NetworkManager.shared.fetchData(from: weeklyOffStatus_Url, as: weekOffDataResponse.self
            )
            self.weeklyOffData = response
            print("The weekOff response is \(response)")
        }
        catch {
            print("Error fetching Data is \(error)")
        }
    }
}
