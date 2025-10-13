////
////  LeaveStatusView.swift
////  GoDairy
////
////  Created by San eforce on 06/09/25.
////
//
import SwiftUI

struct LeaveStatusView: View {
    @StateObject private var viewModel = leaveStatusViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    StatusSection(title: "LEAVE STATUS") {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.leaveStatusData, id: \.Leave_Id) { item in
                                LeaveStatusCard(item: item)
                            }
                        }
                    }
                }
                .padding(5)
            }
            .task { await viewModel.fetchLeaveStatusData() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LeaveStatusCard: View {
    let item: leaveStatusModel
    
    var body: some View {
        StatusBaseCard {
            HStack {
                Text("\(item.From_Date ?? "") TO \(item.To_Date ?? "")")
                    .regularTextStyle(size: 11, foreground: .black, fontWeight: .medium)
                Spacer()
                if let color = Color(cssRGB: item.StusClr ?? "") {
                    Text(item.LStatus ?? "")
                        .regularTextStyle(size: 12, foreground: .white, fontWeight: .bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(color)
                        .cornerRadius(12)
                }
            }
            
            Divider().background(.gray)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("TYPE").font(.caption).foregroundColor(.gray)
                        Text(item.Leave_Type ?? "")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("DAYS").font(.caption).foregroundColor(.gray)
                        Text(String(format: "%.f", item.No_of_Days ?? 0.0))
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("REASON").font(.caption).foregroundColor(.gray)
                    Text(item.Reason ?? "")
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
            }
            
            HStack {
                Text("Applied: \(item.Created_Date ?? "")")
                Spacer()
                if item.LStatus?.lowercased() == "approved" || item.LStatus?.lowercased() == "pending" {
                    Text("Approved: \(item.LastUpdt_Date ?? "_____")")
                } else {
                    Text("Rejected: \(item.LastUpdt_Date ?? "_____")")
                }
            }
            .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
        }
    }
}

#Preview {
    LeaveStatusView()
}


