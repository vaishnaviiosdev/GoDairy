//
//  PermissionStatusView.swift
//  GoDairy
//
//  Created by San eforce on 10/10/25.
//

import SwiftUI

struct PermissionStatusView: View {
    @StateObject private var viewModel = permissionStatusViewmodel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    StatusSection(title: "PERMISSION STATUS") {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.permissionStatusData) { item in
                                PermissionStatusCard(item: item)
                            }
                        }
                    }
                }
                .padding(5)
            }
            .onAppear {
                Task {
                    await viewModel.fetchPermissionData()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PermissionStatusCard: View {
    let item: permissionDataResponse
    
    var body: some View {
        StatusBaseCard {
            HStack {
                Text("\(item.Permissiondate ?? "")")
                    .regularTextStyle(size: 11, foreground: .black, fontWeight: .medium)
                Spacer()
                if let color = Color(cssRGB: item.StusClr ?? "") {
                    Text(item.PStatus ?? "")
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
                        Text("\(item.FromTime ?? "") TO \(item.ToTime ?? "")")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("HOURS").font(.caption).foregroundColor(.gray)
                        Text(item.Noof_hours ?? "")
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
                Text("Applied: \(item.Created_Date ?? "---")")
//                Spacer()
//                if item.LStatus?.lowercased() == "approved" || item.LStatus?.lowercased() == "pending" {
//                    Text("Approved: \(item.LastUpdt_Date ?? "_____")")
//                } else {
//                    Text("Rejected: \(item.LastUpdt_Date ?? "_____")")
//                }
            }
            .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
        }
    }
}

#Preview {
    PermissionStatusView()
}

