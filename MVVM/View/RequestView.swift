//
//  RequestView.swift
//  GoDairy
//
//  Created by San eforce on 06/01/25.
//
//import SwiftUI
//
//struct RequestView: View {
//    
//    @State private var navigatetoDashboard = true
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 16) {
//                    // Request Section
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text("REQUEST")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                            .background(Color("App_Primary"))
//                        
//                        NavigationLink(destination: AdvanceStatusView()) {
//                            RequestRow(title: "Advance Request")
//                        }
//                        NavigationLink(destination: LeaveRequestView()) {
//                            RequestRow(title: "Leave Request")
//                        }
//                        NavigationLink(destination: PermissionView()) {
//                            RequestRow(title: "Permission Request")
//                        }
//                        NavigationLink(destination: MIssedPunchview()) {
//                            RequestRow(title: "Missed Punch ")
//                        }
//                        NavigationLink(destination: WeeklyOffView()) {
//                            RequestRow(title: "Weekly-Off ")
//                        }
//                        NavigationLink(destination: DeviationEntryView()) {
//                            RequestRow(title: "Deviation Entry ")
//                        }
//                    }
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                    
//                    // Status Section
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text("STATUS")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                            .background(Color("App_Primary"))
//                        
//                        NavigationLink(destination: AdvanceStatusView()) {
//                            StatusRow(title: "Advance Request")
//                        }
//                        
//                        NavigationLink(destination: LeaveRequestView()) {
//                            StatusRow(title: "Leave Request")
//                        }
//                        
//                        NavigationLink(destination: PermissionView()) {
//                            StatusRow(title: "Permission Request")
//                        }
//                        
//                        NavigationLink(destination: MIssedPunchview()) {
//                            StatusRow(title: "Missed Punch ")
//                        }
//                        NavigationLink(destination: WeeklyOffView()) {
//                            StatusRow(title: "Weekly-Off ")
//                        }
//                        NavigationLink(destination: DeviationEntryView()) {
//                            StatusRow(title: "Deviation Entry ")
//                        }
//                    }
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                }
//                .padding(.vertical, 8)
//            }
//            .background(Color(UIColor.systemGray6))
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                                ToolbarItem(placement: .navigationBarTrailing) {
//                                    NavigationLink(destination: checkInDashboard(),isActive: $navigatetoDashboard) {
//                                        EmptyView()
//                                        Image(systemName: "house.fill")
//                                            .foregroundColor(.white)
//                                    }
//                                }
//                            }
//            .toolbarBackground(Color("App_primary"), for: .navigationBar)
//        }
//        .navigationTitle("")
//    }
//}
//
//struct RequestRow: View {
//    let title: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//                .foregroundColor(.black)
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//                .padding(.trailing)
//        }
//        .background(Color.white)
//        Divider()
//            .padding(.leading)
//    }
//}
//
//struct StatusRow: View {
//    let title: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//                .foregroundColor(.black)
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//                .padding(.trailing)
//        }
//        .background(Color.white)
//        Divider()
//            .padding(.leading)
//    }
//}
//
//struct AdvanceStatusView: View {
//    var body: some View {
//        Text("AdvanceRequest")
//    }
//}
//
//struct LeaveStatusView: View {
//    var body: some View {
//       Text("LeaveReuquest")
//    }
//}
//
//struct PermissionView: View {
//    var body: some View {
//       Text("PermissionRequest")
//    }
//}
//
//struct WeeklyOffView: View {
//    var body: some View {
//       Text("Weekly-Off ")
//    }
//}
//
//struct DeviationEntryView: View {
//    var body: some View {
//       Text("Deviation Entry ")
//    }
//}

import SwiftUI

struct RequestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigatetoDashboard = true
    
    // Reusable list of items
    private let requestItems: [(title: String, destination: AnyView)] = [
        ("Advance Request", AnyView(AdvanceStatusView())),
        ("Leave Request", AnyView(LeaveRequestView())),
        ("Permission Request", AnyView(PermissionView())),
        ("Missed Punch", AnyView(MIssedPunchview())),
        ("Weekly-Off", AnyView(WeeklyOffView())),
        ("Deviation Entry", AnyView(DeviationEntryView()))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
            HStack {
                Color.appPrimary
                Spacer() // pushes the house to the right
                Button(action:{
                    dismiss()
                }){
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                        .padding(.trailing, 16) // optional padding from edge
                }
            }
            .frame(height: 40)
            .background(Color.appPrimary)
            ScrollView {
                VStack(spacing: 16) {
                    // Request Section
                    SectionCard(title: "REQUEST", items: requestItems)
                    // Status Section
                    SectionCard(title: "STATUS", items: requestItems)
                }
                .padding(.vertical, 8)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            //            .toolbar {
            //                ToolbarItem(placement: .navigationBarTrailing) {
            //                    NavigationLink(destination: checkInDashboard(), isActive: $navigatetoDashboard) {
            //                        Image(systemName: "house.fill")
            //                            .foregroundColor(.white)
            //                    }
            //                }
            //            }
            //            .toolbarBackground(Color("App_Primary"), for: .navigationBar)
                Spacer()
        }
        }
        .ignoresSafeArea(.all)
        .navigationTitle("")
    }
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                // Custom top bar
//                HStack {
//                    Spacer() // pushes the house to the right
//                    Image(systemName: "house.fill")
//                        .foregroundColor(.white)
//                        .padding(.trailing, 16) // optional padding from edge
//                }
//                .frame(height: 40)
//                .background(Color.appPrimary)
//
//                // Scroll content
//                ScrollView {
//                    VStack(spacing: 16) {
//                        SectionCard(title: "REQUEST", items: requestItems)
//                        SectionCard(title: "STATUS", items: requestItems)
//                    }
//                    .padding(.vertical, 8)
//                }
//                .background(Color(UIColor.systemGray6))
//            }
//            //.ignoresSafeArea(edges: .top)
//            .navigationTitle("")
//        }
//    }

}

//
// MARK: - Reusable Section Card
//
struct SectionCard: View {
    let title: String
    let items: [(title: String, destination: AnyView)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color("App_Primary"))
            
            ForEach(0..<items.count, id: \.self) { index in
                NavigationLink(destination: items[index].destination) {
                    RowView(title: items[index].title)
                        .onAppear() {
                            print("Row \(index) appeared")
                        }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Reusable Row
struct RowView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
            .background(Color.white)
            
            Divider()
                .padding(.leading)
        }
    }
}

//
// MARK: - Example Destination Views
//
struct AdvanceStatusView: View { var body: some View { Text("AdvanceRequest") } }
//struct LeaveRequestView: View { var body: some View { Text("LeaveRequest") } }
struct PermissionView: View { var body: some View { Text("PermissionRequest") } }
//struct MIssedPunchview: View { var body: some View { Text("Missed Punch") } }
struct WeeklyOffView: View { var body: some View { Text("Weekly-Off") } }
struct DeviationEntryView: View { var body: some View { Text("Deviation Entry") } }

#Preview {
    RequestView()
}
