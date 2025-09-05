//
//  planview.swift
//  GoDairy
//
//  Created by San eforce on 26/11/24.
//
import SwiftUI
import Alamofire


struct workTypes : Codable{
  //  let uuid = UUID()
     let id: String
    let name: String
     let ETabs: String
     let FWFlg: String
     let Place_Involved: String
}


struct workType : Hashable{
  //  let uuid = UUID()
     let id: String
    let name: String
     let ETabs: String
     let FWFlg: String
     let Place_Involved: String
}



struct ModalView: View {
    
    @Binding var isPresented: Bool
    @State private var workType: String = ""
    @State private var workTypecode: String = ""
    @State private var remarks: String = ""
    let currentDate = Date()
    
    @State private var selectedWorkType: String = "Select"
    @State private var navigatetoDashboard = false
    @State private var isSubmitting = false 
    
    @State private var lists:[workTypes] = []
    @State private var Getlists:[workType] = []
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                VStack(spacing: 0) {
                   // Spacer()
                    HStack {
                        Spacer()
                            .frame(height: 150)
                        Button(action: {
                            isPresented = false
                        }) {
                            ZStack{
                                Spacer()
                                Circle()
                                    .foregroundColor(Color(white:0.9))
                                    .frame(width: 50, height: 50)
                                Image(systemName: "xmark")
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.black)
                                   // .padding()
                            }
                        }
                        .padding(.top,20)
                        .padding(.trailing,20)
                    }
                    Text("My Day Plan")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("(\(formattedDate(currentDate)))")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                   // heightAnchor.constraint(equalToConstant: 40),
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("WORK TYPE")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top,32)
                        
                        Menu {
                            ForEach(Getlists, id:\.self) { type in
                                Button(type.name) {
                                    selectedWorkType = type.name
                                    workType = type.name
                                    workTypecode = type.id
                                    
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedWorkType)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal,20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("REMARKS")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading,20)
                            .padding(.top,24)
                        
                        TextField("Type...", text: $remarks)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    
                            )
                    }
                    .padding(.horizontal,20)
                    Spacer(minLength: 150)
                        //.frame(maxWidth: 100)
                    
                    Button(action: {
                     //   submitDayPlan()
                        saveMydayplan()
                       
                    }) {
                        Text( "SUBMIT")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("App_Primary"))
                            .cornerRadius(8)
                        
                    }
                    .padding(.horizontal,20)
                    .padding(.bottom,30)
                    .disabled(isSubmitting)
                    
                }
                .padding(.horizontal,30)
                .frame(maxHeight: .infinity)
                .background(Color.white)
               .cornerRadius(30)
                .padding(.top,100)
                //Spacer()
            }
            .background(Color.black.opacity(0.4))
            .edgesIgnoringSafeArea(.all)
//            .frame(height: 600)
//            .background(Color.white)
             //  .cornerRadius(50)
//            .padding()
            .background(
                NavigationLink(
                    destination: checkInDashboard(),
                   // destination: MapLocation(),
                    isActive: $navigatetoDashboard){
                    EmptyView()
                }
            )
        }
        .onAppear{
          //  PostViewModel()
            worktypes()
        }
    }
    func work(){
        let Types = workTypes(
            id: "",
            name: "",
             ETabs: "",
            FWFlg: "",
             Place_Involved: ""
        )
        
        let data = try! JSONEncoder().encode(Types)
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/worktypes"
        print(urlString)
        
        let url = URL(string: urlString )!
        var request = URLRequest(url: url)
        request.httpBody = data
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode

                if statusCode == 200 {
                    print("SUCCESS")
                } else {
                    print("FAILURE")
                }
        }
        task.resume()
        
    }
    
    func works(){
        let params : [String : Any] = [
            "SF": "MGR80",
            "div": "1"
        ]
        
        let param : [String : Any] = ["data" : "{\"SF\": \"MGR80\",\"div\": \"1\"}"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: param)
        print(param)
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/worktypes"
        print(urlString)
        
        let url = URL(string: urlString )!
        
        var urlComponents = URLComponents(string: urlString)
                
                // If parameters are provided, add them as query items to the URL
                if !params.isEmpty {
                    urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                }
                
                // Ensure the URL is valid
                guard let url = urlComponents?.url else {
                  //  completion(.failure(URLError(.badURL)))
                    return
                }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     //   request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
            }
            if let responseJSON2 = responseJSON as? [[String: Any]] {
                print(responseJSON2)
                
            }
        }.resume()
    }
    
//    func worktypes(){
//
//                let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/worktypes"
//             print(urlString)
//                guard let url = URL(string: urlString) else {
//                    print("Invalid URL")
//                    return
//                }
//        
////        let work = workTypes(
////             //uuid = UUID()
////              id: String
////            name: String
////              ETabs: String
////             FWFlg: String
////              Place_Involved: String
////        }
////        )
//
//        //let data = try! JSONEncoder().encode(work)
//        let parameters: [String: Any] = [
//                    "SF": "MGR80",
//                    "div": "1"
//                ]
//        
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
//                   print("Error: Cannot convert parameters to JSON")
//                   return
//               }
//        print(parameters)
//                var request = URLRequest(url: url)
//                request.httpMethod = "POST"
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                   print(data)
//                    guard let httpResponse = response as? HTTPURLResponse,
//                          (200...299).contains(httpResponse.statusCode),
//                          let data = data else {
//                        print("Invalid response or no data")
//                        return
//                    }
//                    do {
//                                    
//                                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                                    if let responseDict = jsonResponse as? [String: Any],
//                                       let type = responseDict["work_types"] as? [String] {
//                                        DispatchQueue.main.async {
//                                           // workType = type
//                                            print(responseDict)
//                                        }
//                                    }
//                                } catch let parseError as NSError {
//                                    // Detailed parsing error log
//                                    print("JSON parsing error: \(parseError.localizedDescription)")
//                                    print("Raw Data: \(String(data: data, encoding: .utf8) ?? "No data")")
//                                }
//                            }
//                            
//                            task.resume()
//                        }
    
    
    func worktypes(){
        let apiKey = "get/worktypes"
        let aFormData: [String: Any] = [
            "SF": "MGR80",
            "div": "1"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        
        print(params)
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL2 + apiKey, method: .post,parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(response)
                    if let json = value as? [AnyObject]{
                        for i in json{
                            Getlists.append(GoDairy.workType(id: String(i["id"] as? Int ?? 0), name: i["name"] as? String ?? "", ETabs: i["ETabs"] as? String ?? "", FWFlg: i["FWFlg"] as? String ?? "", Place_Involved: i["Place_Involved"] as? String ?? ""))
                        }
                        
                        print(Getlists)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
   
    private func submitDayPlan() {
        isSubmitting = true
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedCurrentDate = formatter.string(from: currentDate)
        
        
        let requestBody: [[String: Any]] = [
            ["Tp_Dayplan": [
                "worktype_code": "'\(workType)'",
                "dcr_activity_date": "'\(formattedCurrentDate)'",
                "worktype_name": "''",
                "Ekey": "EKMGR80-1981473274",
                "objective": "'\(remarks)'",
                "Flag": "''",
                "Button_Access": "",
                "MOT": "''",
                "DA_Type": "''",
                "Driver_Allow": "'0'",
                "From_Place": "''",
                "To_Place": "''",
                "MOT_ID": "''",
                "To_Place_ID": "''",
                "Mode_Travel_ID": "''",
                "worked_with": "'null'",
                "jointWorkCode": "'null'"
            ],
             "Tp_DynamicValues": []]
        ]
        
        print(requestBody)
        
        guard let url = URL(string: "http://qa.godairy.in/server/db_new_activity.php?State_Code=1&desig=MGR&divisionCode=1&axn=save/dayplandynamic&sfCode=MGR80") else {
            isSubmitting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            isSubmitting = false
            print("Error serializing request body: \(error)")
            return
        }
        
       
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
            }
            
            if let error = error {
                print("Error with API request: \(error)")
                return
            }
            
          /*  guard let data = data else {
                print("No data received")
                return
            }*/
            
            guard data != nil else {
                print(data)
                print("No data received")
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully submitted day plan")
               // navigatetoDashboard = true
                DispatchQueue.main.async {
                                navigatetoDashboard = true
                            }
                
            } else {
                print("Failed to submit day plan. Response: \(response!)")
            }
        }.resume()
    }
    
    
    func saveMydayplan(){
        isSubmitting = true
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedCurrentDate = formatter.string(from: currentDate)
        
        let aFormData: [String: Any] = [
            "Tp_Dayplan": [
                "worktype_code": "'\(workTypecode)'",
                "dcr_activity_date": "'\(formattedCurrentDate)'",
                "worktype_name": "'\(workType)'",
                "Ekey": "EKMGR80-1981473274",
                "objective": "'\(remarks)'",
                "Flag": "''",
                "Button_Access": "",
                "MOT": "''",
                "DA_Type": "''",
                "Driver_Allow": "'0'",
                "From_Place": "''",
                "To_Place": "''",
                "MOT_ID": "''",
                "To_Place_ID": "''",
                "Mode_Travel_ID": "''",
                "worked_with": "'null'",
                "jointWorkCode": "'null'"
            ],
             "Tp_DynamicValues": []
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: aFormData, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        print(params)
        
        var Sf_code:String=""
        var divisionCode:String = ""
        if let sfCode = UserDefaults.standard.string(forKey: "Sf_code") {
            Sf_code = sfCode
            print("Sf_code: \(sfCode)")
        }

        if let divCode = UserDefaults.standard.string(forKey: "Division_Code") {
            divisionCode = divCode
            print("Division_Code: \(divCode)")
        }
        let apiKey = "save/dayplandynamic&State_Code=1&desig=MGR&divisionCode=\(divisionCode)&sfCode=\(Sf_code)"
        
    //http://qa.godairy.in/server/db_new_activity.php?State_Code=1&desig=MGR&divisionCode=1&axn=save/dayplandynamic&sfCode=MGR80
        
        AF.request(APIClient.shared.BaseURL + APIClient.shared.db_new_activity + apiKey, method: .post,parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(response)
                    DispatchQueue.main.async {
                        isSubmitting = false
                    }
                  
                    DispatchQueue.main.async {
                                    navigatetoDashboard = true
                                }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
}

class PostViewModel: ObservableObject {
    @Published var successMessage: String? = nil
    @Published var errorMessage: String? = nil
    @Published var isSubmitting = false
    
    // Function to send POST request
    func sendPostData(postData: workTypes) {
        // 1. Prepare URL for the API
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/worktypes"
        print(urlString)
        
        let url = URL(string: urlString )!
        
        // 2. Create the URLRequest and set the HTTP method to "POST"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. Encode the PostData into JSON
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(postData)
            request.httpBody = jsonData
        } catch {
            self.errorMessage = "Failed to encode data: \(error.localizedDescription)"
            return
        }
        
        // 4. Perform the network request
        isSubmitting = true
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isSubmitting = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received"
                }
                return
            }
            
            // Handle the response (optionally decode the response, if any)
            // In this case, we'll assume the server responds with the same data we sent
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(workTypes.self, from: data)
                DispatchQueue.main.async {
                    self?.successMessage = "Data submitted successfully! Received: \(decodedResponse.name)"
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response"
                }
            }
        }
        .resume() // Start the task
    }
}


