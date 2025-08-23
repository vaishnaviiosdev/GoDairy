//
//  ContentView.swift
//  GoDairy
//
//  Created by San eforce on 07/08/24.
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 4){//qad-801090
//                    Color(red:25/255,green: 151/255,blue: 206/255)
                    Color.appPrimary
                    Color.white
                      }
                    .ignoresSafeArea()
                    
                    Image("Group 15")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        
                        //.frame(width: 400.11,height: 600.97,alignment: .topLeading)
               
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
                           // .frame(width: 250,height: 30)
                            .frame(maxWidth: .infinity,alignment: .trailing)
                            .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                               
                           // .multilineTextAlignment(.leading)
                            
                            Text("Delivery Solutions")
                                //.frame(width: 400,height: 30)
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
                      /*  NavigationLink(
                            destination: gmail()
                                .toolbarRole(.editor),
                            label: {
                                Continuebtn()
                                    .toolbarRole(.editor)
                            })*/
                       
                    }
                    
                    Spacer(minLength: 75)
                    VStack {
//                        Text("Powered by")
//                            .font(.caption)
//                            .foregroundColor(.gray)
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
    
    struct gmail:View {
        var body: some View {
            Text("Continue with google")
        }
    }
    
    struct page:View {
        
        @StateObject private var viewModel = DataViewModel()
        var body: some View {
            
            NavigationView {
                VStack {
                    List {
                        Button("GET", action: {
                            viewModel.fetchData()
                        })
                        
                        ForEach(viewModel.data) { item in
                            VStack(alignment: .leading) {
                                Text("title: \(item.title)")
                                Text("base_url: \(item.base_url)")
                            }
                        }
                        
                    }
                    
                    HStack {
                        Spacer()
                        //EditButton()
                        Spacer()
                        Spacer()
                    }
                }
                .navigationTitle("Custom List")
                
            }
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
   
    struct forgetbtn:View {
        var body: some View {
            VStack(alignment: .trailing, spacing: 4){
                Text("Forget Password?")
                
                    .frame(maxWidth: .infinity,alignment: .trailing)
                // .background(Color.white)
                    .font(.caption)
                  //  .background(Color(red:255/255,green: 151/255,blue: 206/255))
                    .foregroundColor(.primary)
            }
            .padding()
            
        }
    }
    
    struct Continuebtn: View {
        let image:String = ""
        var body: some View {
            HStack {
               Image("Group 2")
                .background(Color.white)
                .font(.headline)
                .foregroundColor(.black)
                .cornerRadius(9)
                
                Text("Continue with google")
                    .foregroundColor(.black)
                    .frame(width:200,height: 50,alignment: .center)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
