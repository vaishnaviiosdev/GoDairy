//
//  ActivityDashboardView.swift
//  GoDairy
//
//  Created by San eforce on 11/09/25.
//

import SwiftUI

struct ActivityDashboardView: View {
    var body: some View {
        ZStack {
            Color.backgroundColour
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ActivityDashboardHeader(sfName: sf_name)
                    
                    OutletSummaryView()
                    
                    Spacer(minLength: 30)
                    
                    ActivityGridItemView()
                    Spacer(minLength: 20)
                    Divider()
                    Spacer(minLength: 10)
                    
                    todayOrdersView()
                }
            }
        }
        .padding(.bottom, 20.0)
        
        .navigationBarBackButtonHidden(true)
    }
}

//MARK: - HEADER VIEW
struct ActivityDashboardHeader: View {
    var sfName: String

    var body: some View {
        HStack() {
            Image("p1")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(5)
            VStack(alignment: .leading, spacing: 4) {
                Text(sf_name.isEmpty ? "Guest User" : sf_name)
                    .font(.headline)
                    .bold()
                Text(sf_Designation.isEmpty ? "---" : sf_Designation)
                    .font(.system(size: 13))
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct OutletSummaryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Outlet Summary")
                    .font(.title3)
                    .fontWeight(.regular)
                    .padding(.bottom)
                Spacer()
                
                HStack(spacing: 8) {
                    Text("2025-09-11")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 12)
                .frame(height: 50)
                .background(.appPrimary3)
                .cornerRadius(10)
            }
            
            Spacer(minLength: 30)
            
            HStack {
                VStack(alignment: .center, spacing: 10) {
                    Text("Service Outlets")
                        .font(.headline)
                        .fontWeight(.medium)
                    Text("281")
                        .font(.title)
                        .foregroundColor(.appPrimary3)
                }
                Spacer()
                Rectangle()
                    .fill(Color.appPrimary3)
                    .frame(width: 2, height: 40)
                Spacer()
                VStack(alignment: .center, spacing: 10) {
                    Text("Non Service Outlets")
                        .font(.headline)
                        .fontWeight(.medium)
                    Text("12")
                        .font(.title)
                        .foregroundColor(.appPrimary3)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ActivityGridItemView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
            ForEach(menuItems, id: \.title) { item in
                NavigationLink(destination: item.destination) {
                    VStack {
                        if item.isSystemIcon {
                            Image(systemName: item.icon)
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                        }
                        else {
                            Image(item.icon) // asset
                                .resizable()
                                .renderingMode(.original) // keeps original colors
                                .frame(width: 28, height: 28)
                        }
                        
                        Text(item.title)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct todayOrdersView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Today Orders")
                    .font(.headline)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    // your action here
                }) {
                    Text("View All")
                        .font(.headline)
                        .foregroundColor(.appPrimary3)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, 10)
            
            HStack(alignment: .center, spacing: 15) {
                VStack(alignment: .center, spacing: 10) {
                    Text("Total Value")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    Text("0.00")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.appPrimary3)
                }
                Spacer()
                VStack(alignment: .center, spacing: 10) {
                    Text("Primary Order")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    Text("0")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.appPrimary3)
                }
                Spacer()
                VStack(alignment: .center, spacing: 10) {
                    Text("No Order")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    Text("216")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.appPrimary3)
                }
            }
            .padding()
            
            Text("Last Updated on : 2025-10-11")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                //.padding(.top, 5)
        }
    }
}

struct MenuItem {
    let title: String
    let icon: String
    let isSystemIcon: Bool
    let destination: AnyView
}

let menuItems: [MenuItem] = [
    MenuItem(title: "Primary Order", icon: "PrimaryOrder", isSystemIcon: false, destination: AnyView(LeaveRequestView())), 
    MenuItem(title: "Secondary Order", icon: "SecondaryOrder", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Van Sales", icon: "delivery-van", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "OverDue List", icon: "SecondaryOrder", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Outlets", icon: "shop", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Geo Tagging", icon: "shop", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Primary Delivery", icon: "delivery-van", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Nearby Outlets", icon: "shop-lock", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Reports", icon: "reports", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Distributor", icon: "chart", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "New Distributor", icon: "smiley", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Customer Onboarding", icon: "chart", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "My Team", icon: "users", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Beat Master", icon: "smiley", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
    MenuItem(title: "Feedback", icon: "smiley", isSystemIcon: false, destination: AnyView(LeaveRequestView())),
]

#Preview {
    ActivityDashboardView()
}
