//
//  ViewModel.swift
//  GoDairy
//
//  Created by San eforce on 18/08/25.
//

import Foundation
import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    @Published var data: [fetchResponse] = []
    @Published var mydayplanData: [mydayplanDataResponse] = []
    
    func fetchData() async {
        do {
            let response: [fetchResponse] = try await NetworkManager.shared.fetchData(
                from: milk_url,
                as: [fetchResponse].self
            )
            self.data = response   // ✅ safely updates on main thread
            print("Response: \(response)")
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func getWorkTypesData(sf: String, div: String) async {
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/worktypes"
        guard let url = URL(string: urlString) else { return }
        
        let body: [String: Any] = [
            "data": [
                "SF": sf,
                "div": div
            ]
        ]
        
        do {
            let response: [mydayplanDataResponse] = try await NetworkManager.shared.postData(to: url.absoluteString, parameters: body, as: [mydayplanDataResponse].self)
            print("The getworkTypesData response is \(response) and \(body)")
        }
        catch {
            print("Failed to get work Types Data")
        }
    }
}

//func saveProducts() async {
//    guard let url = URL(string: save_Request) else { return }
//
//    let parameters: [String: Any] = [
//        "data": products.map { [
//            "product_code": $0.product_code,
//            "product_name": $0.product_name,
//            "product_unit": $0.product_unit,
//            "convQty": $0.convQty,
//        ]}
//    ]
//    do {
//        let response: SaveProductsResponse = try await NetworkManager.shared.postData(to: url.absoluteString, parameters: parameters, as: SaveProductsResponse.self)
//        print(response)
//        saveSuccessMessage = "Products saved successfully"
//        showSaveSuccessAlert = true
//    }
//    catch {
//        saveSuccessMessage = "Please try again later"
//        showSaveSuccessAlert = true
//        print("Failed to post data: \(error)")
//    }
//}


//func fetchData() {
//    let url = URL(string: "https://admin.godairy.in/server/milk_url_config.json")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//        if let error = error {
//            print("Error while fetching data:", error)
//            return
//        }
//        guard let data = data else {
//            print("No data received")
//            return
//        }
//        do {
//            let fetchedData = try JSONDecoder().decode([Get].self, from: data)
//            DispatchQueue.main.async {
//                self?.data = fetchedData
//            }
//        } catch let jsonError {
//            print("Failed to decode JSON:", jsonError)
//        }
//    }
//    task.resume()
//}

//@MainActor
//class ProductViewModel: ObservableObject {
//    @Published var products: [Product] = []
//    @Published var errorMessage: String?
//    @Published var showDeleteConfirmation = false
//    @Published var showDeleteSuccess = false
//    @Published var productToDelete: Product?
//    @Published var showSaveSuccessAlert = false
//    @Published var saveSuccessMessage: String = ""
//
//    func loadProducts() async {
//        errorMessage = nil
//        do {
//            products = try await NetworkManager.shared.fetchData(from: fetch_Request, as: [Product].self)
//            print("The products is \(products)")
//        }
//        catch {
//            errorMessage = "Failed to load products: \(error.localizedDescription)"
//        }
//    }
//
//    func saveProducts() async {
//        guard let url = URL(string: save_Request) else { return }
//
//        let parameters: [String: Any] = [
//            "data": products.map { [
//                "product_code": $0.product_code,
//                "product_name": $0.product_name,
//                "product_unit": $0.product_unit,
//                "convQty": $0.convQty,
//            ]}
//        ]
//        do {
//            let response: SaveProductsResponse = try await NetworkManager.shared.postData(to: url.absoluteString, parameters: parameters, as: SaveProductsResponse.self)
//            print(response)
//            saveSuccessMessage = "Products saved successfully"
//            showSaveSuccessAlert = true
//        }
//        catch {
//            saveSuccessMessage = "Please try again later"
//            showSaveSuccessAlert = true
//            print("Failed to post data: \(error)")
//        }
//    }
//    
//    func confirmDelete(_ product: Product) {
//        productToDelete = product
//        showDeleteConfirmation = true
//    }
//
//    func deleteConfirmedProduct() {
//        if let product = productToDelete {
//            deleteProduct(product)
//            showDeleteSuccess = true
//            productToDelete = nil
//        }
//    }
//
//    func deleteProduct(_ product: Product) {
//        products.removeAll { $0.product_code == product.product_code }
//    }
//    
//    func increment(_ product: Product) {
//        if let index = products.firstIndex(where: { $0.product_code == product.product_code }) {
//            print("The index of the products is \(index)")
//            products[index].convQty = String((Int(products[index].convQty) ?? 0) + 1)
//        }
//    }
//
//    func decrement(_ product: Product) {
//        if let index = products.firstIndex(where: { $0.product_code == product.product_code }) {
//            let currentQty = Int(products[index].convQty) ?? 0
//            if currentQty > 0 {
//                products[index].convQty = String(currentQty - 1)
//            }
//        }
//    }
//}
//
