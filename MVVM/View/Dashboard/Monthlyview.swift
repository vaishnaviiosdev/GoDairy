//
//  Monthlyview.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI

struct Monthlyview: View {
    @StateObject var dashboardVM = dashboardViewModel()
    @State private var navigateToNextPages = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                ViewAll(navigateToNextPages: $navigateToNextPages)
                    
                MonthlyList(dashboardVM: dashboardVM)
            }
            .onAppear {
                Task {
                    await dashboardVM.getMonthlyDashboardData()
                }
            }
            .navigationDestination(isPresented: $navigateToNextPages) {
                MonthlyViewAllView()
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
                    .regularTextStyle(size: 16, foreground: .appPrimary, fontWeight: .semibold)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct MonthlyList: View {
    var dashboardVM: dashboardViewModel

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                spacing: 12
            ) {
                MonthlyCard(title: "Permission", value: "\(dashboardVM.monthlyData?.Permission ?? 0)")
                MonthlyCard(title: "Leave", value: "\(dashboardVM.monthlyData?.leave ?? 0)")
                MonthlyCard(title: "Late", value: "\(0)") //not there
                MonthlyCard(title: "On-Time", value: "\(dashboardVM.monthlyData?.vwOnduty ?? 0)")
                MonthlyCard(title: "Missed Punch", value: "\(dashboardVM.monthlyData?.vwmissedpunch ?? 0)")
                MonthlyCard(title: "Weekly off", value: "\(0)") // Not there
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
    }
}

struct MonthlyCard: View {
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
        .frame(minHeight: 85)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    Monthlyview()
}


