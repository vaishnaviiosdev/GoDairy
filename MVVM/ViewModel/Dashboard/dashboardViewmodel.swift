//
//  dashboardViewmodel.swift
//  GoDairy
//
//  Created by San eforce on 19/09/25.
//

import Foundation
import SwiftUI

@MainActor
class dashboardViewModel: ObservableObject {
    @Published var dashboardData: mydayPlanCheckResponse?
    @Published var workTypesData: [mydayplanworkTypeResponse] = []
    @Published var WorkTypeName: [String] = []
    @Published var Todaycheckin_Flag: Int = 0
    
    func fetchDashboardData() async {
        do {
            let formattedTodayDate = Date().formattedAsYYYYMMDD()
            
            let myDayPlan_Url = APIClient.shared.New_DBUrl + APIClient.shared.New_DBUrl4 + "desig=MGR&divisionCode=\(division_code)&Sf_code=\(sf_code)&axn=check%2Fmydayplan&Date=\(formattedTodayDate)%2014%3A46%3A13"
            
            let response: mydayPlanCheckResponse = try await NetworkManager.shared.fetchData(from: myDayPlan_Url, as: mydayPlanCheckResponse.self
            )
            self.dashboardData = response
            self.Todaycheckin_Flag = self.dashboardData?.Todaycheckin_Flag ?? 0
            print("the Todaycheckin_Flag is \(Todaycheckin_Flag)")
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
    
    //worktype_url
    func fetchWorkTypeDataPost() async {
        let workTypePayload: [String: Any] = [
            "SF": sf_code,
            "div": division_code
        ]
        
        let parameters: [String: Any] = [
            "data": workTypePayload
        ]
        
        do {
            let response: [mydayplanworkTypeResponse] = try await NetworkManager.shared.postFormData(
                urlString: worktype_url,
                parameters: parameters,
                responseType: [mydayplanworkTypeResponse].self
            )
            self.workTypesData = response
            
            await MainActor.run {
                self.WorkTypeName = response.map { $0.name }
            }
        }
        catch {
            print("Error Fetching Data is \(error)")
        }
    }
}


