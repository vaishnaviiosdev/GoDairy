//
//  ordersViewModel.swift
//  GoDairy
//
//  Created by San eforce on 15/10/25.
//

import Foundation
import SwiftUI

@MainActor
class ordersViewModel: ObservableObject {
    @Published var categoryData: [categoryDataResponse] = []
    @Published var categoryTypeData: [categoryTypeDataResponse] = []
    
    func PostCategoryList(id: String) async {
        let categoryListPayload : [String: Any] = [
            "SF" : sf_code,
            "Stk" : id,
            "outletId" : "OutletCode",
            "div" : division_code
        ]
        
        let parameters: [String:Any] = [
            "data" : categoryListPayload
        ]
        
        do {
            let response : [categoryDataResponse] = try await NetworkManager.shared.postFormData(urlString: prodGroup_Url, parameters: parameters, responseType: [categoryDataResponse].self
            )
            self.categoryData = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
    
    func PostCategoryTypeList(id: String) async {
        let categoryListPayload : [String: Any] = [
            "SF" : sf_code,
            "Stk" : id,
            "outletId" : "OutletCode",
            "div" : division_code
        ]
        
        let parameters: [String:Any] = [
            "data" : categoryListPayload
        ]
        
        do {
            let response : [categoryTypeDataResponse] = try await NetworkManager.shared.postFormData(urlString: prodTypes_Url, parameters: parameters, responseType: [categoryTypeDataResponse].self
            )
            self.categoryTypeData = response
        }
        catch {
            print("Error Fetching data is \(error)")
        }
    }
    
    
}

