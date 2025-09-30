//
//  checkInDashboard.swift
//  GoDairy
//
//  Created by San eforce on 29/09/25.
//

import SwiftUI
import Alamofire

struct checkInDashboard: View {
    @State private var currentTab:Int = 0
    var body: some View {
        NavigationStack{
            ZStack{
                colorData.shared.Background_color
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Image("p1")
                            .resizable()
                        //.scaledToFit()
                            .frame(width: 40,height: 40)
                            .padding(5)
                        VStack(alignment:.leading,spacing: -2){
                            Text("V.Mohana Krishnan")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                            Text("Sales Manager")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image("Notification")
                        Image("power")
                    }
                    .padding()
                    check_in_button1()
                    ZStack(alignment:.center){
                        Rectangle()
                            .foregroundColor(colorData.shared.Background_color)
                        TabbarView(currentTab: $currentTab)
                    }.frame(height: 50)
                    //TabBar(currentTab: $currentTab)
                    Divider()
                    Exploremore1()
                }
            }
        }
    }
}

// MARK: - CHECK IN BUTTON
var isCheckedIn: Bool = false
struct check_in_button1:View {
    // @State private var isCheckedIn: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var isButtonClicked: Bool = false
    @State var startDate = Date.now
    @State private var showDayPlan = false
    @State private var navigateToNextPages = false
    
    @State private var isSubmitting = false
    @State private var workType: String = ""
    @State private var remarks: String = ""
    @State private var navigatetoDashboard = false
    
    @State private var Divcode: String = ""
    @State private var Sf_code: String = ""
    
    @State  var timer: Timer? = nil
    
    @State private var items: [DashboardItem1] = [
       // DashboardItem1(count: "Shift 1", label: "07:00 AM - 04:00 PM"),
       // DashboardItem1(count: "Shift 2", label: "09:00 AM - 06:00 PM"),
       // DashboardItem1(count: "Shift TEST A", label: "10:10 AM - 11:10 AM")
    ]
    // @State  var timerPublisher: AnyCancellable? = nil
    
    //var furtureDate = Date.now.addingTimeInterval(3000)
    //let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Lets get to work")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Image("write")
                    Spacer()
                    //.frame(maxHeight: .infinity)
                }
                
                
                
                Button(action: {
                    
                    if !isCheckedIn {
                        // Handle Check Out
                        Checkin()
                       CheckDayPlan()
                    } else {
                        // Handle Check In
                       // MissedPunch()
                        checkOut()
                       
                        stopTimer()
                    }
                   // isCheckedIn.toggle()
                    //   Checkin()
                    // self.navigateToNextPages = true
                    //showDayPlan = true
                    // self.isButtonClicked.toggle()
                    /* NavigationLink(
                     destination: MapLocation(),
                     label: {
                     checkInDashboard()
                     })*/
                    // self.buttonColor = self.buttonColor == .blue ? colorData.shared.check_out_color : colorData.shared.check_out_color
                }){
                    
                    
                    
                    ZStack{
                        
                        Rectangle()
                            .foregroundColor(isCheckedIn ? colorData.shared.check_out_color : Color("App_Primary"))
                        // .foregroundColor(isButtonClicked ? colorData.shared.Appcolor : colorData.shared.Appcolor)
                        //.background(buttonColor)
                        // .foregroundColor(colorData.shared.Appcolor)
                            .frame(height: 50)
                            .cornerRadius(10)
                        
                        //Text("CHECK IN")
                        //                    Button("CHECK IN")
                        //                    {
                        //                        //showDayPlan = true
                        //                        //   self.navigateToNextPages = true
                        //
                        //                    }
                        Text(isCheckedIn ? "CHECK OUT \(formatTime(elapsedTime))" : "CHECK IN")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        
                        //.fullScreenCover(isPresented: $showDayPlan) {
                        // MapLocation()
                        //}
                        
                        // Text(isButtonClicked ? "CHECK OUT" : "CHECK IN")
                        
                        /* Text( "CHECK IN")
                         .foregroundColor(.white)
                         .fontWeight(.bold)
                         }*/
                        
                        
                        
                        /* ZStack{
                         Button(action: {
                         showDayPlan = true
                         }){
                         ZStack {
                         Rectangle()
                         .foregroundColor(colorData.shared.Appcolor)
                         .frame(maxWidth: .infinity)
                         .frame(height: 30)
                         .cornerRadius(10)
                         
                         Text("My Day Plan")
                         .foregroundColor(.white)
                         .font(.system(size: 16,weight: .medium))
                         }
                         }
                         .fullScreenCover(isPresented: $showDayPlan){
                         DayPlanPopup(isPresented: $showDayPlan)
                         }
                         }*/
                        
                    }
                }
                .padding(.horizontal,20)
            }
            .background(
                NavigationLink(
                    
                    destination: MapLocation(),
                    isActive: $navigatetoDashboard){
                    EmptyView()
                }
            )
            .background(
                NavigationLink(destination: MissedPunchView(),
                               isActive: $navigateToNextPages){
                    EmptyView()
                }
            )
//            .onAppear{
//                MissedPunch()
//            }
            .onAppear{
                if isCheckedIn {
                    startTimer()
                }
                
            }
           /* .onAppear{
                MissedPunch()
            }*/
        }
//        NavigationLink(destination: MapLocation(),
//                       isActive: $navigateToNextPages){
//            EmptyView()
//        }
                       .onDisappear{
                           timer?.invalidate()
                       }
    }

    func formatTime(_ time: TimeInterval) -> String {
         
           let minutes = Int(time) / 60
           let seconds = Int(time) % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }
    
    
    private func Checkin() {
        
        startDate = Date()
        startTimer()

        isSubmitting = true
        DispatchQueue.main.async {
                        navigatetoDashboard = true
                    }
        
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
    func startTimer() {
       
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(startDate)
        }
    }
    func stopTimer() {
        
        timer?.invalidate()
        timer = nil
        print("Elapsed time: \(elapsedTime) seconds")
    }


    private func checkOut() {
       
        stopTimer()
        MissedPunch()
        navigateToNextPages = true
        
       
        isSubmitting = true
//        DispatchQueue.main.async {
//            navigatetoDashboard = true
//        }
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
                "ShiftEnd":" ' \(elapsedTime)'",
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
        
       
        let apiKey = "get/logouttime&Ekey=EKMGR801260237946&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)&State_Code=&desig="
        
   
        
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
                        UserDefaults.standard.set(false, forKey: "User_Login")
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
    
    func MissedPunch() {
               
//        isSubmitting = true
//
//        DispatchQueue.main.async {
//            navigateToNextPages = true
//              }
        
        
        var Sf_code:String=""
        var divisionCode:String = ""
        
        let requestBody: [String: Any] = [
            "CheckWK":[],
                "GetMissed":[],
                "Msg":"",
                "WKFlg":1
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        print(params)
        
        //http://qa.godairy.in/server/Db_v300.php?&axn=CheckWeekofandmis&divisionCode=1&sfCode=MGR80&State_Code=&desig=
       
        let apiKey = "CheckWeekofandmis&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)&State_Code=&desig="
        
   
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
    
    func CheckDayPlan(){
        
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
        let requestBody: [[String: Any]] =
            [
                ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let params: Parameters = ["data": jsonString]
        print(params)
        
   //http://qa.godairy.in/server/Db_v300.php?desig=MGR&divisionCode=1&Sf_code=MGR80&axn=check%2Fmydayplan&Date=2024-12-27%2014%3A46%3A13
        
        
        let apiKey = "check/mydayplan&Date=2024-12-27&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)&State_Code=&desig="
        
       
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
    
    // MARK: - TABBAR VIEW
    
    struct TabbarView1: View {
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
    
    // MARK: - TABBARItems VIEW
    struct TabbarItems1:View {
        @Binding var currentTab:Int
        let namespace:Namespace.ID
        var TabbarItemName:String
        var Tab:Int
        var body: some View {
            
            Button(action: {
                currentTab = Tab
            }){
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                    VStack{
                        if currentTab == Tab{
                            Text(TabbarItemName)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.top,8)
                        }else{
                            Text(TabbarItemName)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.top,8)
                        }
                        
                        if currentTab == Tab{
                            Color.blue
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "underline", in: namespace,properties: .frame)
                        }else{
                            Color.clear.frame(height: 2)
                        }
                    }.animation(.spring(),value: currentTab)
                }
            }.buttonStyle(.plain)
        }
    }
    
    
    // MARK: - TABBAR
    struct TabBar1:View {
        @Binding var currentTab:Int
        var body: some View {
            ZStack(alignment: .top){
                TabView(selection: $currentTab){
                    //Todayview().tag(0)
                    Monthlyview().tag(1)
                    Gate_in_out().tag(2)
                    //Login().tag(2)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                
            }
        }
    }

//struct ExploreGrid: View {
//    let title: String
//    let items: [GridItemModel]
//    @Binding var requestStatus: Bool
//
//    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.headline)
//                .padding(.horizontal)
//
//            LazyVGrid(columns: columns) {
//                ForEach(items) { item in
//                    Button {
//                        item.action?($requestStatus)
//                    } label: {
//                        GridItemView(item: item)
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Grid Item Model
//struct GridItemModel: Identifiable {
//    let id = UUID()
//    let name: String
//    let image: String
//    var action: ((Binding<Bool>) -> Void)? = nil
//}
//
//// MARK: - Reusable Grid Item View
//struct GridItemView: View {
//    let item: GridItemModel
//
//    var body: some View {
//        VStack {
//            Image(item.image)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//
//            Text(item.name)
//                .font(.subheadline)
//                .lineLimit(1)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color.white.opacity(0.1))
//        .cornerRadius(10)
//        .shadow(radius: 2)
//    }
//}
    
    
    // MARK: - Explore More GridView
    struct Exploremore1: View {
        let colums = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        var body: some View {
            NavigationView {
                ScrollView {
                    HStack {
                        Text("Explore More")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    
                    LazyVGrid(columns: colums) {
                        GridView_item1(name: "GateIN", image: "GateIN")
                        GridView_item1(name: "Gate OUT", image: "GateOUT")
                        GridView_item1(name: "SFA", image: "users-gear 1")
                        GridView_item1(name: "TA & claim", image: "TA")
                        GridView_item1(name: "Request & Status", image: "Vector")
                        GridView_item1(name: "Canteen Scan", image: "CS")
                    }
                    .padding(.bottom)
                }
            }
        }
    }

    // MARK: - Explore More GridView item as Button
    struct GridView_item1: View {
        
        let colums = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        var name: String
        var image: String
        
        var body: some View {
            Button(action: {
                // Add your action here, like navigation or alert
                NavigationLink(destination: forgetpass()) {
                       Text("Go to Detail")
                     }
                
                print("\(name) tapped")
            }) {
                VStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text(name)
                        .font(.system(size: 15))
                        .foregroundColor(.black) // Adjust the text color
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 5) // Optional: Add shadow for better button effect
                )
                .padding(4) // Add padding around the entire button
            }
            .buttonStyle(PlainButtonStyle()) // Avoid default button styling that might conflict
        }
    }



#Preview {
    checkInDashboard()
}
