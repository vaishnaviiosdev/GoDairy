////
////  Dashboard.swift
////  GoDairy
////
////  Created by San eforce on 05/10/24.
////
//
//import SwiftUI
//import Alamofire
//
//struct Dashboard: View {
//    @State private var currentTab:Int = 0
//    @State private var sfName:String = ""
//    
//    var body: some View {//qad-801090
//        ZStack {
//            Color.backgroundColour
//                .edgesIgnoringSafeArea(.all)
//            ScrollView {
//                VStack {
//                    DashboardHeader(sfName: sfName)
//                    //check_in_button()
//                    CheckInSection()
//                    ZStack(alignment:.center) {
//                        Rectangle()
//                            .foregroundColor(Color.white)
//                        TabbarView(currentTab: $currentTab)
//                    }.frame(height: 50)
//                    TabBar(currentTab: $currentTab)
//                    Divider()
//                    ExploreMore()
//                }
//            }
//        }
//        .padding(.bottom, 20.0)
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            sfName = UserDefaults.standard.string(forKey: "Sf_Name") ?? ""
//        }
//    }
//}
//
//// MARK: - HEADER VIEW
//struct DashboardHeader: View {
//    var sfName: String
//    
//    var body: some View {
//        HStack {
//            Image("p1")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//                .padding(5)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Hi! \(sfName.isEmpty ? "Guest User" : sfName)")
//                    .font(.headline)
//                    .bold()
//                Text("Sales Manager")
//                    .font(.subheadline)
//            }
//            Spacer()
//            Image("power")
//                .resizable()
//                .frame(width: 30, height: 30)
//                .padding(5)
//        }
//        .padding()
//    }
//}
//
//// MARK: - CHECK IN SECTION
//struct CheckInSection: View {
//    @State private var showDayPlan = false
//    @State private var btnTitle = "My Day Plan"
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text("Let’s get to work")
//                    .font(.system(size: 12, weight: .semibold))
//                Image("write")
//                Spacer()
//            }
//
//            CustomBtn(
//                title: btnTitle,
//                height: 50,
//                backgroundColor: Color.appPrimary
//            ) {
//                showDayPlan = true
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//// MARK: - CHECK IN BUTTON
////struct check_in_button:View {
////    //@State private var isButtonClicked: Bool = false
////    @State var startDate = Date.now
////    @State private var showDayPlan = false
////    @State private var navigatetoDashboard = false
////    @State private var isSubmitting = false
////    @State private var btnTitle = "My Day Plan"
////    var furtureDate = Date.now.addingTimeInterval(3000)
////    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
////    
////    var body: some View {
////        VStack {
////            HStack {
////                Text("Lets get to work")
////                    .font(.system(size: 12))
////                    .fontWeight(.semibold)
////                Image("write")
////                Spacer()
////            }
////            Spacer().frame(height: 15)
////            CustomBtn(title: btnTitle, height: 50, backgroundColor: Color.appPrimary) {
////                showDayPlan = true
////            }
////            //.padding(.horizontal, 10)
////                
////                    //.padding(.horizontal, 5)
////            
////            
//////            Button(action: {
//////               showDayPlan = true
//////            }) {
//////                ZStack {
//////                Rectangle()
//////                    .foregroundColor(colorData.shared.Appcolor)
//////                    .frame(maxWidth: .infinity)
//////                    .frame(height: 30)
//////                    .cornerRadius(30)
//////                Button("My Day Plan") {
//////                    showDayPlan = true
//////                }
//////                .foregroundColor(.white)
//////                .fullScreenCover(isPresented: $showDayPlan) {
//////                    ModalView(isPresented: $showDayPlan)
//////                }
//////            }
//////            }
////        }
////        .padding(15)
////    }
////    
////    func CheckDayPlan() {
////        var Sf_code:String=""
////        var divisionCode:String = ""
////        if let sfCode = UserDefaults.standard.string(forKey: "Sf_code") {
////            Sf_code = sfCode
////            print("Sf_code: \(sfCode)")
////        }
////
////        if let divCode = UserDefaults.standard.string(forKey: "Division_Code") {
////            divisionCode = divCode
////            print("Division_Code: \(divCode)")
////        }
////        let requestBody: [[String: Any]] =
////            [
////                ]
////        
////        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
////        let jsonString = String(data: jsonData!, encoding: .utf8)!
////        let params: Parameters = ["data": jsonString]
////        print(params)
////        
////   //http://qa.godairy.in/server/Db_v300.php?desig=MGR&divisionCode=1&Sf_code=MGR80&axn=check%2Fmydayplan&Date=2024-12-27%2014%3A46%3A13
////        
////        
////        let apiKey = "check/mydayplan&Date=2024-12-27%2014%3A46%3A13&divisionCode=\(divisionCode)&Sf_code=\(Sf_code)&State_Code=&desig="
////        
////  
////        
////        AF.request(APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey, method: .post,parameters: params)
////            .validate(statusCode: 200..<300)
////            .responseJSON { response in
////                switch response.result {
////                case .success(let value):
////                    print(response)
////                    DispatchQueue.main.async {
////                        isSubmitting = false
////                    }
////                  
////                    DispatchQueue.main.async {
////                                    navigatetoDashboard = true
////                                }
////                case .failure(let error):
////                    print("Request failed with error: \(error)")
////                }
////            }
////    }
////}
//
////// MARK: - CUSTOM TABBAR
////struct CustomTabbar: View {
////    @Binding var currentTab: Int
////    @Namespace private var namespace
////
////    private let options = ["Today", "Monthly", "Gate IN/OUT"]
////
////    var body: some View {
////        HStack(spacing: 0) {
////            ForEach(options.indices, id: \.self) { index in
////                TabbarItem(
////                    title: options[index],
////                    isSelected: currentTab == index,
////                    namespace: namespace
////                ) {
////                    currentTab = index
////                }
////            }
////        }
////        .frame(height: 50)
////        .background(colorData.shared.Background_color)
////    }
////}
//
// //MARK: - TABBAR VIEW
////struct TabbarView: View {
////    @Binding var currentTab:Int
////    @Namespace var namespace
////    var tapbaroption: [String] = ["Today","Monthly","Gate IN/OUT"]
////    var body: some View {
////        HStack(spacing:1) {
////            ForEach(Array(zip(tapbaroption.indices, tapbaroption)),id: \.0){ index, name in
////                TabbarItems(currentTab: self.$currentTab, namespace: namespace, TabbarItemName: name, Tab: index).padding(.vertical,1)
////
////                }
////            }
////        }
////}
//
//struct TabbarView: View {
//    @Binding var currentTab:Int
//    @Namespace var namespace
//    var tapbaroption: [String] = ["Today","Monthly","Gate IN/OUT"]
//
//    var body: some View {
//        HStack {
//            ForEach(Array(zip(tapbaroption.indices, tapbaroption)), id: \.0) { index, name in
//                TabbarItems(currentTab: $currentTab,
//                            namespace: namespace,
//                            TabbarItemName: name,
//                            Tab: index)
//            }
//        }
//        .frame(height: 50)
//        .background(colorData.shared.Background_color) // ✅ background once here
//    }
//}
//
//
//struct TabbarItems: View {
//    @Binding var currentTab:Int
//    let namespace:Namespace.ID
//    var TabbarItemName:String
//    var Tab:Int
//    
//    var body: some View {
//        Button(action: {
//            currentTab = Tab
//        }) {
//            VStack(spacing: 4) {
//                Text(TabbarItemName)
//                    .font(.system(size: 15, weight: .semibold))
//                    .foregroundColor(currentTab == Tab ? .black : .gray)
//                    .padding(.top, 8)
//                
//                Rectangle()
//                    .fill(currentTab == Tab ? Color.blue : Color.clear)
//                    .frame(height: 2)
//                    .matchedGeometryEffect(id: "underline", in: namespace)
//            }
//            .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.plain)
//    }
//}
//
////// MARK: - TABBARItems VIEW
////struct TabbarItems:View {
////    @Binding var currentTab:Int
////    let namespace:Namespace.ID
////    var TabbarItemName:String
////    var Tab:Int
////    var body: some View {
////        
////        Button(action: {
////            currentTab = Tab
////        }){
////            ZStack{
////                Rectangle()
////                    .foregroundColor(.white)
////            VStack{
////                if currentTab == Tab {
////                    Text(TabbarItemName)
////                        .font(.system(size: 15))
////                        .fontWeight(.semibold)
////                        .foregroundColor(.black)
////                        .padding(.top,8)
////                }
////                else {
////                    Text(TabbarItemName)
////                        .font(.system(size: 15))
////                        .fontWeight(.semibold)
////                        .foregroundColor(.gray)
////                        .padding(.top,8)
////                }
////                
////                if currentTab == Tab {
////                    Color.blue
////                        .frame(height: 2)
////                        .matchedGeometryEffect(id: "underline", in: namespace,properties: .frame)
////                }
////                else {
////                    Color.clear.frame(height: 2)
////                }
////            }.animation(.spring(),value: currentTab)
////            }
////        }.buttonStyle(.plain)
////    }
////} //Old one
//
//
//// MARK: - TABBAR
//
//struct TabBar:View {
//    @Binding var currentTab:Int
//    var body: some View {
//        ZStack(alignment: .top) {
//            TabView(selection: $currentTab) {
//                Todayview().tag(0)
//                Monthlyview().tag(1)
//                Gate_in_out().tag(2)
//                //Login().tag(2)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//}
//
//struct ExploreMore: View {
//    @State private var showRequestStatus = false
//    
//    let items: [(name: String, image: String, action: (() -> Void)?)] = [
//        ("Request & Status", "request", { }),
//        ("TA & claim", "ta&claim", nil),
//        ("Activity", "activity", nil),
//        ("GateIN", "Group 5", nil),
//        ("Gate OUT", "Group", nil),
//        ("TP", "calendar", nil),
//        ("Extended Shift", "Group 5", nil),
//        ("Approvals", "CS", nil)
//    ]
//    
//    let columns = Array(repeating: GridItem(.flexible()), count: 3)
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
////                Text("Explore More")
////                   .font(.system(size: 18, weight: .semibold))
////                    .frame(maxWidth: .infinity, alignment: .leading)
////                    .padding()
//                
//                LazyVGrid(columns: columns) {
//                    ForEach(items, id: \.name) { item in
//                        Button {
//                            if item.name == "Request & Status" {
//                                showRequestStatus = true
//                            }
//                            item.action?()
//                        } label: {
//                            GridItemView(name: item.name, image: item.image)
//                        }
//                        .buttonStyle(.plain)
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $showRequestStatus) {
//                RequestView()
//            }
//        }
//    }
//}
//
//struct GridItemView: View {
//    let name: String
//    let image: String
//    
//    var body: some View {
//        VStack {
//            Image(image)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 30, height: 30)
//                .padding(.bottom, 5)
//            Text(name)
//                .font(.system(size: 12))
//                //.lineLimit(1)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .cornerRadius(8)
//        .shadow(radius: 2)
//    }
//}
//
//#Preview {
//    Dashboard()
//}
//


