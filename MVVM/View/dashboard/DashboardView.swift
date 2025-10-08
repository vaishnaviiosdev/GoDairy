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
    @State private var showCheckOutAlert = false
    @State private var goToDashboard = false
    @State private var showSheet: Bool = true
    @State private var showDayPlan = false
    @StateObject var dashboardVM = dashboardViewModel()
    @State private var myDayPlanCount = 0
    @State private var goToCheckIn = false
    @State private var goToCheckOut = false
    @State private var startFromStep = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        DashboardHeader(sfName: sf_name)
                    
                        CheckInSection(
                            goToCheckIn: $goToCheckIn,
                            showDayPlan: $showDayPlan,
                            startFromStep: $startFromStep,
                            goToCheckOut: $goToCheckOut,
                            myDayPlanCount: dashboardVM.checkDayPlanData.count,
                            btnTitle: dashboardVM.btnTitle,
                            btnBackgroundColor: dashboardVM.btnBackgroundColor,
                            dashboardVM: dashboardVM
                        )
                            .padding(.bottom, 10)
                                                
                        ZStack(alignment: .center) {
                            TabbarView(currentTab: $currentTab)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

                        TabBar(currentTab: $currentTab, myDayPlanCount: dashboardVM.checkDayPlanData.count)
                            .frame(height: 250)
                        
                        Divider()
                            .frame(height: 0.3)
                            .background(Color.gray)
                        
                        ExploreMore()
                    }
                }
                
                // 🔹 Bottom Sheet Overlay
                if showDayPlan {
                    ZStack(alignment: .bottom) {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showDayPlan = false
                                }
                            }
                        
                        VStack {
                            Spacer()
                            DayPlanView(showSheet: $showDayPlan)
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
            .onAppear {
                Task {
                    await dashboardVM.fetchDashboardData()
                    await dashboardVM.getMonthlyDashboardData()
                }
            }
            .navigationDestination(isPresented: $goToCheckIn) {
                let cnt = dashboardVM.dashboardData?.Checkdayplan?.first?.Cnt ?? 0
                let wtype = dashboardVM.dashboardData?.Checkdayplan?.first?.wtype ?? "0"
                let checkOnDuty = dashboardVM.dashboardData?.CheckOnduty
                CheckInFlowView(Cnt: cnt, wrkType: wtype, checkOnDuty: checkOnDuty, titleName: "Check In", isFirstTimeCheckIn: dashboardVM.isFirstTimeCheckIn)
            }
        }
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
                UserDefaults.standard.removeObject(forKey: "Sf_code")
                UserDefaults.standard.removeObject(forKey: "Division_Code")
                UserDefaults.standard.removeObject(forKey: "Sf_Name")
                UserDefaults.standard.removeObject(forKey: "sf_Designation_Short_Name")
                isLoggedIn = false
                router.root = .login
            }
            Button("No", role: .cancel) {
            
            }
        }
    }
}

struct CheckInSection: View {
    @State private var showCheckOutAlert = false
    @State private var checkoutTitle: String = ""
    @Binding var goToCheckIn: Bool
    @Binding var showDayPlan: Bool
    @Binding var startFromStep: Int
    @Binding var goToCheckOut: Bool
    var myDayPlanCount: Int
    var btnTitle: String
    var btnBackgroundColor: Color
    var dashboardVM: dashboardViewModel

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
                backgroundColor: btnBackgroundColor
            ) {
                withAnimation(.spring()) {
                    if myDayPlanCount > 0 {
                        if dashboardVM.btnTitle.uppercased().starts(with: "CHECK OUT") {
                            showCheckOutAlert = true
                        }
                        else {
                            startFromStep = dashboardVM.isFirstTimeCheckIn ? 0 : 2
                            dashboardVM.isFirstTimeCheckIn = false
                            goToCheckIn = true
                        }
                    }
                    else {
                        showDayPlan = true
                    }
                }
            }
        }
        .padding(.horizontal)
        .alert("Do you want to Checkout?", isPresented: $showCheckOutAlert) {
            Button("Yes", role: .destructive) {
                goToCheckOut = true
                checkoutTitle = "Check Out"
            }
            Button("No", role: .cancel) {
            
            }
        }
        .navigationDestination(isPresented: $goToCheckOut) {
            CheckInFlowView(
                Cnt: dashboardVM.checkDayPlanData.first?.Cnt ?? 0,
                wrkType: dashboardVM.checkDayPlanData.first?.wtype ?? "",
                checkOnDuty: dashboardVM.dashboardData?.CheckOnduty,
                titleName: "Check Out",
                startFromStep: startFromStep, //2
                isFirstTimeCheckIn: dashboardVM.isFirstTimeCheckIn
            )
        }
    }
}

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
}

struct TabbarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabbarOptions: [String] = ["TODAY", "MONTHLY", "GATE IN/OUT"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab buttons
            HStack(spacing: 0) {
                ForEach(Array(zip(tabbarOptions.indices, tabbarOptions)), id: \.0) { index, name in
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentTab = index
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(name)
                                .font(.system(size: 15, weight: currentTab == index ? .semibold : .regular))
                                .foregroundColor(currentTab == index ? .black : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 48)
            .background(Color.white)
            
            // Underline indicator at bottom
            ZStack(alignment: .leading) {
                Color.gray.opacity(0.2)
                    .frame(height: 1)
                GeometryReader { geometry in
                    let tabWidth = geometry.size.width / CGFloat(tabbarOptions.count)
                    
                    Color(red: 0.01, green: 0.66, blue: 0.96)
                        .frame(width: tabWidth, height: 2)
                        .offset(x: tabWidth * CGFloat(currentTab))
                        .matchedGeometryEffect(id: "underline", in: namespace)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentTab)
                }
            }
            .frame(height: 2)
        }
        .background(Color.white)
    }
}

// MARK: - TABBAR
struct TabBar: View {
    @Binding var currentTab: Int
    var myDayPlanCount: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab) {
                Todayview(myDayPlanCount: myDayPlanCount).tag(0)
                Monthlyview().tag(1)
                Gate_in_out().tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
    }
}

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
        .fullScreenCover(isPresented: $showTAClaim) { MonthlyViewAllView() }
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


