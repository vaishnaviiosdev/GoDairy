//
//  DashboardView.swift
//  GoDairy
//
//  Created by San eforce on 22/08/25.
//

import SwiftUI
import Alamofire

struct DashboardView: View {
    @State private var currentTab:Int = 0
    @State private var showLogoutAlert = false
    @State private var goToDashboard = false
    @State private var showDayPlan = false  // overlay state
    
    var body: some View {
        ZStack {
            Color.backgroundColour
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    DashboardHeader(sfName: sf_name)
                    
                    CheckInSection(showDayPlan: $showDayPlan)
                    
                    ZStack(alignment:.center) {
                        Rectangle().foregroundColor(colorData.shared.Background_color)
                        TabbarView(currentTab: $currentTab)
                    }
                    .frame(height: 50)
                    
                    TabBar(currentTab: $currentTab)
                        .frame(height: 300)
                    
                    Divider()
                    ExploreMore()
                }
            }
            
            // 🔹 Bottom Sheet Overlay
            if showDayPlan {
                ZStack(alignment: .bottom) {
                    // dim background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showDayPlan = false
                            }
                        }
                    
                    VStack {
                        Spacer()
                        DayPlanView()
                            .frame(maxWidth: .infinity, maxHeight: 400) // height adjust
                            .background(Color.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                            .shadow(radius: 10)
                            .transition(.move(edge: .bottom))
                    }
                }
                .animation(.spring(), value: showDayPlan)
            }
        }
        .padding(.bottom, 20.0)
        .navigationBarBackButtonHidden(true)
    }
}


//MARK: - HEADER VIEW
struct DashboardHeader: View {
    var sfName: String
    @State private var showLogoutAlert = false
    @EnvironmentObject var router: AppRouter
    @AppStorage("User_Login") var isLoggedIn: Bool = false
    
    var body: some View {
        HStack {
            Image("p1")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(5)
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi! \(sf_name.isEmpty ? "Guest User" : sf_name)") .font(.headline)
                    .bold()
                Text(sf_Designation.isEmpty ? "---" : sf_Designation)
                    .font(.system(size: 13))
            }
            Spacer()
            Button(action: {
                //router.root = .login
                showLogoutAlert = true
            }) {
                Image("power")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(5)
            }
        }
        .padding()
        .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
            Button("Yes", role: .destructive) {
                isLoggedIn = false
                router.root = .login
            }
            Button("No", role: .cancel) {
            
            }
        }
    }
}

struct CheckInSection: View {
    @Binding var showDayPlan: Bool
    @State private var btnTitle = "My Day Plan"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Let’s get to work")
                    .font(.system(size: 12, weight: .semibold))
                Image("write")
                Spacer()
            }
            CustomBtn(
                title: btnTitle,
                height: 50,
                backgroundColor: Color.appPrimary
            ) {
                withAnimation(.spring()) {
                    showDayPlan = true
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - CHECK IN SECTION
//struct CheckInSection: View {
//    @State private var showDayPlan = false
//    @State private var btnTitle = "My Day Plan"
//    
//    var body: some View {
//        ZStack {
//            VStack(alignment: .leading, spacing: 12) {
//                HStack {
//                    Text("Let’s get to work")
//                        .font(.system(size: 12, weight: .semibold))
//                    Image("write")
//                    Spacer()
//                }
//                CustomBtn (
//                    title: btnTitle,
//                    height: 50,
//                    backgroundColor: Color.appPrimary
//                ) {
//                    withAnimation(.spring()) {
//                        showDayPlan = true
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .overlay(
//            Group {
//                if showDayPlan {
//                    DayPlanView()
//                        .frame(maxHeight: 450)
//                        .background(Color.white)
//                        .cornerRadius(20, corners: [.topLeft, .topRight])
//                        .transition(.move(edge: .bottom))
//                }
//            }, alignment: .bottom
//        )
//    }
//}

// MARK: - CHECK IN BUTTON
struct CheckInButton: View {
    @State private var isButtonClicked: Bool = false
    @State var startDate = Date.now
    @State private var showDayPlan = false
    @State private var navigatetoDashboard = false
    @State private var isSubmitting = false
    @State private var btnTitle = "My Day Plan"
    
    var futureDate = Date.now.addingTimeInterval(3000)
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    
    var body: some View {
        VStack {
            HStack {
                Text("Let's get to work")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                
                Image("write")
                Spacer()
            }
            
            Spacer().frame(height: 15)
            
            CustomBtn(
                title: btnTitle,
                height: 50,
                backgroundColor: Color.appPrimary
            ) {
                showDayPlan = true
            }
            .padding(.horizontal, 10)
        }
        .padding(15)
    }
    
    // MARK: - API CALL
    func checkDayPlan() {
        var sfCode: String = ""
        var divisionCode: String = ""
        
        if let code = UserDefaults.standard.string(forKey: "Sf_code") {
            sfCode = code
            print("Sf_code: \(code)")
        }
        
        if let divCode = UserDefaults.standard.string(forKey: "Division_Code") {
            divisionCode = divCode
            print("Division_Code: \(divCode)")
        }
        
        let requestBody: [[String: Any]] = []
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        
        let params: Parameters = ["data": jsonString]
        print(params)
        
        // Example API key (update as needed)
        let apiKey = "check/mydayplan&Date=2024-12-27%2014%3A46%3A13&divisionCode=\(divisionCode)&Sf_code=\(sfCode)&State_Code=&desig="
        
        AF.request(
            APIClient.shared.BaseURL + APIClient.shared.DBURL + apiKey,
            method: .post,
            parameters: params
        )
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print(response)
                DispatchQueue.main.async {
                    isSubmitting = false
                    navigatetoDashboard = true
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

// MARK: - TABBAR VIEW
struct TabbarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tapbaroption: [String] = ["TODAY", "MONTHLY", "GATEIN/OUT"]
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(Array(zip(tapbaroption.indices, tapbaroption)), id: \.0) { index, name in
                TabbarItems(
                    currentTab: self.$currentTab,
                    namespace: namespace,
                    TabbarItemName: name,
                    Tab: index
                )
                .padding(.vertical, 1)
            }
        }
    }
}

// MARK: - TABBAR ITEMS VIEW
struct TabbarItems: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var TabbarItemName: String
    var Tab: Int
    
    var body: some View {
        Button(action: {
            currentTab = Tab
        }) {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                
                VStack {
                    if currentTab == Tab {
                        Text(TabbarItemName)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.top, 8)
                    }
                    else {
                        Text(TabbarItemName)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    
                    if currentTab == Tab {
                        Color.blue
                            .frame(height: 2)
                            .matchedGeometryEffect(
                                id: "underline",
                                in: namespace,
                                properties: .frame
                            )
                    } else {
                        Color.clear.frame(height: 2)
                    }
                }
                .animation(.spring(), value: currentTab)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - TABBAR
struct TabBar: View {
    @Binding var currentTab: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab) {
                Todayview().tag(0)
                Monthlyview().tag(1)
                Gate_in_out().tag(2)
                // Login().tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - EXPLORE MORE
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
//        LazyVGrid(columns: columns) {
//            ForEach(items, id: \.name) { item in
//                Button {
//                    if item.name == "Request & Status" {
//                        showRequestStatus = true
//                    }
//                    item.action?()
//                } label: {
//                    GridItemView(name: item.name, image: item.image)
//                }
//                .buttonStyle(.plain)
//            }
//        }
//        .fullScreenCover(isPresented: $showRequestStatus) {
//            RequestView()
//        }
//    }
//}

struct ExploreMore: View {
    @State private var showRequestStatus = false
    @State private var showTAClaim = false
    @State private var showActivity = false
    @State private var showGateIn = false
    @State private var showGateOut = false
    @State private var showTP = false
    @State private var showExtendedShift = false
    @State private var showApprovals = false
    
    var body: some View {
        let items: [(name: String, image: String, action: () -> Void)] = [
            ("Request & Status", "chart-user 1", { showRequestStatus = true }),
            ("TA & claim", "TA&Claim", { showTAClaim = true }),
            ("Activity", "users-gear 1", { showActivity = true }),
            ("GateIN", "Group 5", { showGateIn = true }),
            ("Gate OUT", "Group 6", { showGateOut = true }),
            ("TP", "calendar_1", { showTP = true }),
            ("Extended Shift", "Group 5", { showExtendedShift = true }),
            ("Approvals", "approval", { showApprovals = true })
        ]
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
            ForEach(items, id: \.name) { item in
                Button(action: item.action) {
                    GridItemView(name: item.name, image: item.image)
                }
                .buttonStyle(.plain)
            }
        }
        // MARK: - FullScreen Modals
        .fullScreenCover(isPresented: $showRequestStatus) { RequestView() }
//        .fullScreenCover(isPresented: $showTAClaim) { TAClaimView() }
        .fullScreenCover(isPresented: $showActivity) { ActivityDashboardView() }
//        .fullScreenCover(isPresented: $showGateIn) { GateInView() }
//        .fullScreenCover(isPresented: $showGateOut) { GateOutView() }
//        .fullScreenCover(isPresented: $showTP) { TPView() }
//        .fullScreenCover(isPresented: $showExtendedShift) { ExtendedShiftView() }
        .fullScreenCover(isPresented: $showApprovals) { ApprovalMainView() }
    }
}


// MARK: - GRID ITEM VIEW
struct GridItemView: View {
    let name: String
    let image: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .clipped() 
                .padding(.bottom, 5)
            
            Text(name)
                .font(.system(size: 12))
                // .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// MARK: - PREVIEW
#Preview {
    DashboardView()
}


