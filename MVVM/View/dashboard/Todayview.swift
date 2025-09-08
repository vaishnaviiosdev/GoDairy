//
//  Todayview.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI
import Alamofire

struct Todayview: View {
   // @State var startDate = Date.now
    
    @State private var timeRemaining = 100
    let startDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var furtureDate = Date.now.addingTimeInterval(3000)
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    
    @State var shift_timing:String = ""
    @State var Sf_name:String = ""
    @State var divisionCode:String = ""
    @State var Sf_code:String = ""
    @State private var items: [DashboardItem1] = [
       // DashboardItem1(count: "Shift 1", label: "07:00 AM - 04:00 PM"),
       // DashboardItem1(count: "Shift 2", label: "09:00 AM - 06:00 PM"),
       // DashboardItem1(count: "Shift TEST A", label: "10:10 AM - 11:10 AM")
    ]
    
    var body: some View {
        VStack {
        }.onAppear {
            userAuth1()
        }
        
            VStack {
              /*  Text("In Time: \(timeRemaining)")
                .onReceive(timer){ time in
                    
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }*/
                HStack {
                    Text("11/07/2023")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(10)
                HStack{
                    Text(Date.now...Date.now.addingTimeInterval(31000))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Image("Late")
                    Text("Late")
                        .font(.system(size: 15)).bold()
                        .foregroundColor(colorData.shared.check_out_color)
                }
                .padding()
                HStack {
                   // Spacer()
                    Text("IN time")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                   Spacer()
                        .frame(width: 160)
              
                    Text("OUT time")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Spacer(minLength: 40)
                }
                .padding(10)
                Spacer()
                    .frame(height: 5)
                HStack{
                    Image("p1")
                    TimelineView(.periodic(from: startDate, by: 1.0)) { context in
                        VStack(spacing: 12){
                            Text(context.date,format: dateFormatter)
                        }
                        .font(.subheadline)
                    }
                    Image("marker")
                        .frame(width: 10, height: 10)
                    Text("view")
                        .foregroundColor(.blue)
                        .font(.system(size: 15))
                    Spacer()
                    Image("p1")
                    TimelineView(.periodic(from: startDate, by: 1.0)) { context in
                        VStack(spacing: 12){
                            Text(context.date,format: dateFormatter)
                        }
                        .font(.subheadline)
                    }
                    Image("marker")
                        .frame(width: 10, height: 10)
                    Text("view")
                        .foregroundColor(.blue)
                        .font(.system(size: 15))
                }
                .padding(.top,2)
                Spacer()
                    .frame(height: 5)
                ZStack{
                    HStack{
                        Spacer()
                            
                        Image("A1")
                        Spacer(minLength: 210)
                        Image("A1")
                        Spacer()
                    }
                    //.padding(4)
                }
                
              /*  VStack(spacing:4){
                    HStack{
                        VStack(spacing:4){
                            Image("A1")
                                .foregroundColor(.gray)
                            
                            VStack{
                                Rectangle()
                                    .frame(height: 4)
                            }
                            
                            Text("IN")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                        .frame(width: 30)
                     /*   VStack(alignment:.center){
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.blue)*/
                            
                           Text("12:00:00")
                        //}
                    }
                }*/
                
                VStack{
                    ZStack{
                        Rectangle()
                            //.frame(minWidth: .infinity,maxWidth: 4)
                            //.frame(minHeight: .infinity,maxHeight: 4)
                            .frame(width: 350,height: 4)
                            .foregroundColor(colorData.shared.line_color.opacity(0.3))
                            .cornerRadius(3.0)
                        Rectangle()
                            //.frame(minWidth: .infinity,maxWidth: 4)
                           // .frame(minHeight: .infinity,maxHeight: 4)
                            .frame(width: 220,height: 4)
                            .foregroundColor(Color("App_Primary"))
                            .cornerRadius(5.0)
                    }
                    HStack{
                        Spacer()
                        Text("IN")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Spacer()
                        Text("12:00:00")
                            .foregroundColor(.black)
                        Spacer()
                        Text("OUT")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .padding(2)
               
            }
            
            //.padding(0)
    }
    
    func userAuth1() {
        
        //http://qa.godairy.in/server/Db_v300.php?&axn=get%2FAttnDySty&divisionCode=1&sfCode=MGR80&State_Code=&desig=

        if let sfCode = UserDefaults.standard.string(forKey: "Sf_code") {
            Sf_code = sfCode
           // print("Sf_code: \(sfCode)")
        }

        if let divCode = UserDefaults.standard.string(forKey: "Division_Code") {
            divisionCode = divCode
          //  print("Division_Code: \(divCode)")
        }
       // print(divisionCode)
       // print("Sf_code=\(Sf_code)")
        let urlString = APIClient.shared.BaseURL + APIClient.shared.DBURL + "get/AttnDySty&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)State_Code=&desig="
        print(urlString)
       
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("Invalid response or no data")
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
            }
            catch let parseError as NSError {
                
                print("JSON parsing error: \(parseError.localizedDescription)")
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
        }
        task.resume()
    }
}

#Preview {
    Todayview()
}
