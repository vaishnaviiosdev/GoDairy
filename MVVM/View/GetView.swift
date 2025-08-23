//
//  GetView.swift
//  GoDairy
//
//  Created by San eforce on 27/09/24.
//
//To get Client URL:
//https://admin.godairy.in/server/milk_url_config.json


//import SwiftUI
//import Combine
//
//class DataViewModel: ObservableObject {
//    @Published var data: [Get] = []
//    
//    func fetchData() {
//        let url = URL(string: "https://admin.godairy.in/server/milk_url_config.json")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            if let error = error {
//                print("Error while fetching data:", error)
//                return
//            }
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//            do {
//                let fetchedData = try JSONDecoder().decode([Get].self, from: data)
//                DispatchQueue.main.async {
//                    self?.data = fetchedData
//                }
//            } catch let jsonError {
//                print("Failed to decode JSON:", jsonError)
//            }
//        }
//        task.resume()
//    }
//}
//
//struct Get: Codable, Identifiable {
//    let id = UUID()
//    let title : String
//    let base_url : String
//}
//
//
//struct GetView: View {
//    @StateObject private var viewModel = DataViewModel()
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    Button("GET", action: {
//                        viewModel.fetchData()
//                    })
//                    
//                    ForEach(viewModel.data) { item in
//                        VStack(alignment: .leading) {
//                            Text("title: \(item.title)")
//                            Text("base_url: \(item.base_url)")
//                            
//                        }
//                    }
//                  
//                }
//                
//                HStack {
//                    Spacer()
//                    //EditButton()
//                    Spacer()
//                    Spacer()
//                }
//            }
//            .navigationTitle("Custom List")
//            
//        }
//
//    }
//}
//
//#Preview {
//    GetView()
//}
