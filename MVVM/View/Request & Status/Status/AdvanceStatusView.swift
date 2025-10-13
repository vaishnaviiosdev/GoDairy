//
//  AdvanceStatusView.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import SwiftUI

struct AdvanceStatusView: View {
    @StateObject private var viewModel = advancestatusviewmodel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    StatusSection(title: "ADVANCE STATUS") {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.advanceStatusDataResponse) { item in
                                AdvanceStatusCard(item: item)
                            }
                        }
                    }
                }
                .padding(5)
            }
            .onAppear {
                Task {
                    await viewModel.fetchAdvanceStatusData()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AdvanceStatusCard: View {
    let item: advStatusDataResponse
    
    var body: some View {
        StatusBaseCard {
            HStack {
                Text("\(item.From_Date ?? "") TO \(item.To_Date ?? "")")
                    .regularTextStyle(size: 11, foreground: .black, fontWeight: .medium)
                Spacer()

                let bgColor: Color = {
                    let status = (item.LStatus ?? "").lowercased()
                    if status.contains("reject") {
                        return .emptyReject
                    }
                    else if status.contains("approve") {
                        return .approved
                    }
                    else {
                        return Color(hex: item.StusClr ?? "#CCCCCC")
                    }
                }()

                Text(item.LStatus ?? "")
                    .regularTextStyle(size: 12, foreground: .white, fontWeight: .bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(bgColor)
                    .cornerRadius(12)
            }
            
            Divider().background(.gray)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("TYPE").font(.caption).foregroundColor(.gray)
                        Text(item.AdvTyp ?? "---")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("AMOUNT")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(item.AdvAmt ?? 0)")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("LOCATION").font(.caption).foregroundColor(.gray)
                        Text(item.AdvLoc ?? "---")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("SETTLEMENT DATE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(item.AdvSettle ?? "---")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("PURPOSE").font(.caption).foregroundColor(.gray)
                    Text(item.AdvPurp ?? "")
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
            }
            
            HStack {
                Text("Applied: \(item.eDate ?? "---")")
                Spacer()
                if item.LStatus?.lowercased() == "approved" || item.LStatus?.lowercased() == "pending" {
                    Text("Approved: \(item.eDate ?? "_____")")
                }
                else {
                    Text("Rejected on: \(item.ApprDt ?? "_____")")
                }
            }
            .regularTextStyle(size: 13, foreground: .gray, fontWeight: .bold)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    AdvanceStatusView()
}
