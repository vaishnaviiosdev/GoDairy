//
//  shiftview.swift
//  GoDairy
//
//  Created by Dheiveeka on 27/11/24.
//

import SwiftUI
import Combine 
struct DashboardItem1: Identifiable {
    let uuid = UUID()
    let id : String
    let shiftTime: String
    let startTime: String
    let endTime : String

}

struct ShiftView: View {
    
    enum CheckInStep {
        case location, shift, selfie
    }
    @State private var currentStep: CheckInStep = .shift

    //    @Binding var shift_timing:String
    //    @Binding var divisionCode:String
    //    @Binding var Sf_code:String
    //
    @State var shift_timing:String = ""
    @State var divisionCode:String = ""
    @State var Sf_code:String = ""
    @State private var items: [DashboardItem1] = [
       // DashboardItem1(count: "Shift 1", label: "07:00 AM - 04:00 PM"),
       // DashboardItem1(count: "Shift 2", label: "09:00 AM - 06:00 PM"),
       // DashboardItem1(count: "Shift TEST A", label: "10:10 AM - 11:10 AM")
    ]
    
    @State private var selectedItem: DashboardItem1? = nil
    @State private var navigateToNextPage = false
    @StateObject private var toastManager = ToastManager()
    @State private var isAuthenticated = false
    
    var body: some View{
        NavigationStack{
            VStack {
                
                Spacer()
                    .frame(height: 100)
                
                Text("Check IN")
                    .foregroundColor(.black)
                HStack(spacing: 0) {
                    ForEach([CheckInStep.location, .shift, .selfie], id: \.self) { step in
                        Circle()
                            .fill(currentStep == step ? Color.black : (getStepIndex(step) < getStepIndex(currentStep) ? Color.black : Color.black.opacity(0.2)))
                            .frame(width: 12, height: 12)
                        
                        if step != .selfie {
                            Rectangle()
                                .fill(getStepIndex(step) < getStepIndex(currentStep) ? Color.black : Color.black.opacity(0.2))
                                .frame(height: 2)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                // Step labels
                HStack(spacing: 0) {
                    Text("Location")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    Text("Shift")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    Text("Selfie")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
                .font(.subheadline)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(items) { item in
                        Button(action: {
                            
                            self.selectedItem = item
                        }) {
                            ZStack {
                                VStack(spacing: 5) {
                                    Text(item.shiftTime)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text("\(item.startTime)  \(item.endTime)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                }
                                .padding(20)
                                .background(self.selectedItem?.uuid == item.uuid ? Color("App_Primary").opacity(0.2):       Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                       .stroke(self.selectedItem?.uuid == item.uuid ? Color("App_Primary"): Color.clear,lineWidth: 3)
                                )
                            }
                        }
                    }
                }
                .padding(4)
               /* .onAppear{
                    if let data = UserDefaults.standard.data(forKey: "values"),
                       let decodedArray = try? JSONDecoder().decode([String].self, from: data){
                        print(decodedArray)
                    }
                }*/
                Spacer()
                    .frame(height: 400)
                if let _ = selectedItem {
                    Button(action: {
                        isCheckedIn.toggle()
                        self.navigateToNextPage = true
                        // print("Shift confirmed: \(selectedItem!.count)")
                        
                    }) {
                        Text("Confirm Shift")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("App_Primary"))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 20)
                    }
                    Spacer()
                        .frame(height: 100)
                    
                    //    shiftbutton(toastManager: toastManager, shift_timing: $shift_timing, divisionCode: $divisionCode, Sf_code: $Sf_code)
                }
            }
            .onAppear{
                userAuth()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("")
            .background(
                NavigationLink(destination: CameraView(), isActive: $navigateToNextPage){
                    EmptyView()
                }
            )
        }
        
    }
    
    func userAuth() {
 
        
        if let sfCode = UserDefaults.standard.string(forKey: "Sf_code") {
            Sf_code = sfCode
            print("Sf_code: \(sfCode)")
        }

        if let divCode = UserDefaults.standard.string(forKey: "Division_Code") {
            divisionCode = divCode
            print("Division_Code: \(divCode)")
        }
        print(divisionCode)
        print("Sf_code=\(Sf_code)")
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/Shift_timing&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)"
        print(urlString)
        // Ensure URL is valid
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Ensure a valid HTTP response and data
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("Invalid response or no data")
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let shifts = jsonResponse as? [[String: Any]] {
                    print(shifts)
                    
                    for shift in shifts {
                        let data = DashboardItem1(id: shift["id"] as? String ?? "", shiftTime: shift["name"] as? String ?? "", startTime: shift["Sft_STime"] as? String ?? "", endTime: shift["sft_ETime"] as? String ?? "")
                        items.append(data)
                    }
                    
                    print(items)
                }
            }catch let parseError as NSError {
               
                print("JSON parsing error: \(parseError.localizedDescription)")
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
        }
        task.resume()
    }
    private func getStepIndex(_ step: CheckInStep) -> Int {
        switch step {
        case .location: return 0
        case .shift: return 1
        case .selfie: return 2
        }
    }
}

