//
//  Monthlyview.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI

//struct Monthlyview: View {
//    @StateObject var dashboardVM = dashboardViewModel()
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            
//            // Top header with View All
//            ViewAll()
//                .padding(.horizontal, 16)
//            
//            // Scrollable grid
//            ScrollView {
//                LazyVGrid(
//                    columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
//                    spacing: 12
//                ) {
//                    MonthlyStatCard(title: "Permission", value: "\(dashboardVM.monthlyData?.Permission ?? 0)")
//                    MonthlyStatCard(title: "Leave", value: "\(dashboardVM.monthlyData?.leave ?? 0)")
//                    MonthlyStatCard(title: "Late", value: "\(0)") //not there
//                    MonthlyStatCard(title: "On-Time", value: "\(dashboardVM.monthlyData?.vwOnduty ?? 0)")
//                    MonthlyStatCard(title: "Missed Punch", value: "\(dashboardVM.monthlyData?.vwmissedpunch ?? 0)")
//                    MonthlyStatCard(title: "Weekly off", value: "\(0)") // Not there
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 4)
//            }
//        }
//        .onAppear {
//            Task {
//                await dashboardVM.getMonthlyDashboardData()
//            }
//        }
//    }
//}

struct Monthlyview: View {
    @StateObject var dashboardVM = dashboardViewModel()
    @State private var navigateToNextPages = false // State for navigation
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                
                // Top header with View All
                ViewAll(navigateToNextPages: $navigateToNextPages) // Pass binding to ViewAll
                    
                
                // Scrollable grid
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                        spacing: 12
                    ) {
                        MonthlyStatCard(title: "Permission", value: "\(dashboardVM.monthlyData?.Permission ?? 0)")
                        MonthlyStatCard(title: "Leave", value: "\(dashboardVM.monthlyData?.leave ?? 0)")
                        MonthlyStatCard(title: "Late", value: "\(0)") //not there
                        MonthlyStatCard(title: "On-Time", value: "\(dashboardVM.monthlyData?.vwOnduty ?? 0)")
                        MonthlyStatCard(title: "Missed Punch", value: "\(dashboardVM.monthlyData?.vwmissedpunch ?? 0)")
                        MonthlyStatCard(title: "Weekly off", value: "\(0)") // Not there
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
            }
            .onAppear {
                Task {
                    await dashboardVM.getMonthlyDashboardData()
                }
            }
            
            // NavigationDestination to navigate to MonthlyViewAllView
            .navigationDestination(isPresented: $navigateToNextPages) {
                MonthlyViewAllView() // Your destination view
            }
        }
    }
}

struct ViewAll: View {
    @Binding var navigateToNextPages: Bool

    var body: some View {
        HStack {
            Spacer()
            Button {
                navigateToNextPages = true
            } label: {
                Text("View All")
                    .foregroundColor(.appPrimary)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct MonthlyStatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.appPrimary1)
                    .padding(.horizontal, 8)
                    
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(minHeight: 85) // fixed height only, no infinite width
        .frame(maxWidth: .infinity, alignment: .leading) // align everything left
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    Monthlyview()
}


