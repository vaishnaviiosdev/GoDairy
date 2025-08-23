//
//  Dashboard2.swift
//  GoDairy
//
//  Created by San eforce on 07/10/24.
//

import SwiftUI
import Alamofire

struct Dashboard2: View {
    @State private var currentTab :Int = 0
    
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Image("p1")
                        .resizable()
                        .frame(width: 40,height: 40)
                        .padding(5)
                    VStack(alignment: .leading,spacing: -2) {
                        Text("Head Quaters_1")
                            .font(.headline)
                            .bold()
                        Text("Field Force")
                            .font(.subheadline)
                        
                    }
                    Spacer()
                    Image("Notification")
                }
                .padding()
                check_out_button()
                ZStack(alignment:.center){
                    Rectangle()
                        .foregroundColor(colorData.shared.Background_color)
                    TabBar(currentTab: $currentTab)
                }
                
            }
        }
    }
}

struct check_out_button:View {
    @State private var isSubmitting = false
    @State private var Divcode: String = ""
    @State private var navigatetoDashboard = false
    
    @State private var isButtonClicked: Bool = true
    @State private var hasCheckedIn: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Complete work")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                Image("write")
                Spacer()
            }
            Button(action: {
                if !hasCheckedIn {
                    isButtonClicked.toggle()
                }
            }){
                
                ZStack{
                    
                    Rectangle()
                        .foregroundColor(isButtonClicked ? Color("App_Primary") : colorData.shared.check_out_color)
                    //.background(buttonColor)
                    // .foregroundColor(colorData.shared.Appcolor)
                        .frame(height: 50)
                        .cornerRadius(10)
                    
                    
                    // Text(isButtonClicked ? "CHECK IN" : "CHECK OUT")
                    Text( "CHECK OUT")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .onChange(of: isButtonClicked) { newValue in
                // Once the button is clicked and user checks in, set hasCheckedIn to true
                if !newValue {
                    hasCheckedIn = true
                }
            }
            
        }
        .padding(.horizontal,20)
    }
    
    
    
    private func Checkout() {
        isSubmitting = true
        
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
        
        
        let requestBody: [[String: Any]] = [
            ["TP_Attendance" : [
                "Mode":"CIN",
                "Divcode":" '\(divisionCode)' ",
                "sfCode":"'\(Sf_code)'",
                "Shift_Selected_Id":"",
                "Shift_Name":"",
                "ShiftStart":"",
                "ShiftEnd":"",
                "ShiftCutOff":"",
                "App_Version":"",
                "WrkType":"",
                "CheckDutyFlag":"",
                "On_Duty_Flag":"",
                "vstRmks":"",
                "eDate":"",
                "eTime":"",
                "UKey":"",
                "lat":"",
                "long":"",
                "Lattitude":"",
                "Langitude":"",
                "PlcNm":"",
                "PlcID":"",
                "slfy":""
            ]
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        print(params)
        
        
        let apiKey = "dcr/save&Ekey=EKMGR80377560411&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)&State_Code=&desig="
        
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "dcr/save&Ekey=EKMGR80377560411&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)&State_Code=&desig="
        print(urlString)
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
            
            AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post,parameters: params)
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
    
}


struct TabbarView2: View {
    @Binding var currentTab:Int 
    @Namespace var namespace
    var tapbaroption: [String] = ["Today","Monthly","Gate IN/OUT"]
    var body: some View {
        HStack(spacing:1){
            ForEach(Array(zip(tapbaroption.indices, tapbaroption)),id: \.0){ index, name in
                TabbarItems(currentTab: self.$currentTab, namespace: namespace, TabbarItemName: name, Tab: index).padding(.vertical,1)
                
            }
            }
        }
    }



#Preview {
    Dashboard2()
}
