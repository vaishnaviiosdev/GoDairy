////
////  ContentView.swift
////  GoDairy
////
////  Created by San eforce on 07/08/24.
////
//
import SwiftUI
import Combine
class DataViewModel: ObservableObject {
    @Published var data: [Get] = []
    
    func fetchData() {
        let url = URL(string: "https://admin.godairy.in/server/milk_url_config.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let fetchedData = try JSONDecoder().decode([Get].self, from: data)
                DispatchQueue.main.async {
                    self?.data = fetchedData
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }
        task.resume()
    }
}
struct Get: Codable, Identifiable {
    var id = UUID()
    let title: String
    let base_url: String
}

@available(iOS 16.0, *)
struct ContentView: View {
    
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 4) {
                    Color.appPrimary
                    Color.white
                      }
                    .ignoresSafeArea()
                    
                    Image("Group 15")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 0,maxWidth: .infinity,alignment: .top)
                        .frame(minHeight: 0, maxHeight: .infinity,alignment: .top)
                    .edgesIgnoringSafeArea(.top)
                        
                Image("c1")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200,height: 500)
                
                VStack {
                    HStack {
                        VStack(alignment: .trailing, spacing: 1) {
                            Spacer(minLength: 50)
                            Text("Dairy Product")
                            .frame(maxWidth: .infinity,alignment: .trailing)
                            .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("Delivery Solutions")
                            .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                           Spacer(minLength: 450)
                        }
                    .padding()
                   }
                    VStack {
                        NavigationLink(
                            destination:Login_Page_View(),
                            label: {
                                SignINbutton()
                            })
                        .padding()
                    }
                    Spacer(minLength: 75)
                    VStack {
                        Image("logopic")
                            .resizable()
                            .frame(width: 50,height:50)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
    struct SignINbutton: View {
        var body: some View {
            Text("SIGN IN")
                .frame(width:350,height: 50,alignment: .center)
                .background(Color(red:25/255,green: 151/255,blue: 206/255))
                .font(.headline)
                .foregroundColor(.white)
                .cornerRadius(9)
        }
    }
}

#Preview {
    ContentView()
}
