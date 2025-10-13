////
////  LeaveCancelView.swift
////  GoDairy
////
////  Created by San eforce on 08/09/25.
////
//
import SwiftUI
//
//struct LeaveCancelView: View {
//    
//    @StateObject var leaveCancelData = leaveCancelViewModel()
//    var body: some View {
//        NavigationStack {
//            VStack {
//                homeBar(frameSize: 40)
//                ScrollView {
//                    LeaveCancelStatusCard(title: "LEAVE CANCEL STATUS", leaveCancelModel: leaveCancelData)
//                }
//                .padding(5)
//            }
//            .task {
//                await leaveCancelData.fetchLeaveCancelData()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct LeaveCancelStatusCard: View {
//    let title: String
//    @ObservedObject var leaveCancelModel: leaveCancelViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            titleCard(title: title, frameHeight: 40, fontSize: 14)
//            
//            LeaveCancelStatusList(leaveCancelStatusModel: leaveCancelModel)
//        }
//        .background(Color.backgroundColour)
//        .cornerRadius(12)
//        .padding(.horizontal, 8)
//    }
//}
//
//struct LeaveCancelStatusList: View {
//    @ObservedObject var leaveCancelStatusModel: leaveCancelViewModel
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 10) {
//                LazyVStack(spacing: 20) {
//                    ForEach(leaveCancelStatusModel.leaveCancelData, id: \.id) { item in
//                        LeaveCancelCardDataList(item: item)
//                    }
//                }
//            }
//            .padding(.vertical, 8)
//        }
//}
//
//struct LeaveCancelCardDataList: View {
//    let item: leaveCancelDataResponse
//        
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text("\(item.From_Date ?? "")")
//                    .regularTextStyle(size: 11, foreground: .black, fontWeight: .medium)
//                
//                Spacer()
//                
//                let css = item.StusClr
//                
//                if let color = Color(cssRGB: css ?? "") {
//                    Text(item.LStatus ?? "")
//                        .regularTextStyle(size: 12, foreground: .white, fontWeight: .bold)
//                        .regularTextStyle(size: 12, fontWeight: .bold)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 5)
//                        .background(color)
//                        .cornerRadius(12)
//                }
//            }
//            
//            Divider().background(.gray)
//            
//            // Leave Type, Reason, Days
//            VStack(alignment: .leading, spacing: 16) {
//                HStack {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("TYPE")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        Text(item.Leave_Type ?? "")
//                            .regularTextStyle(size: 14, fontWeight: .semibold)
//                    }
//                    
//                    Spacer()
//                    
//                    VStack(alignment: .trailing, spacing: 2) {
//                        Text("DAYS")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        Text(item.No_of_Days ?? "-")
//                            .regularTextStyle(size: 14, fontWeight: .semibold)
//                    }
//                }
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text("REASON")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text(item.Reason ?? "")
//                        .regularTextStyle(size: 14, fontWeight: .semibold)
//                }
//            }
//            
//            // Applied & Approved/Rejected Date
//            HStack {
//                Text("Applied: \(item.Created_Date ?? "")")
//                    .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
//                
//                Spacer()
//                
//                if item.LStatus?.lowercased() == "approved" || item.LStatus?.lowercased() == "pending" {
//                    Text("Approved : \(item.LastUpdt_Date ?? "_____")")
//                        .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
//                }
//            }
//            
//            Spacer()
//        }
//        .padding(10)
//        .background(
//            RoundedRectangle(cornerRadius: 12).fill(Color.white) // White background
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 12) // Gray border
//                .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
//        )
//        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Same shadow
//        .padding(.horizontal, 5)
//    }
//}
//
//

struct LeaveCancelView: View {
    @StateObject private var viewModel = leaveCancelViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    StatusSection(title: "LEAVE CANCEL STATUS") {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.leaveCancelData, id: \.id) { item in
                                LeaveCancelCard(item: item)
                            }
                        }
                    }
                }
                .padding(5)
            }
            .task { await viewModel.fetchLeaveCancelData() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LeaveCancelCard: View {
    let item: leaveCancelDataResponse
    
    var body: some View {
        StatusBaseCard {
            HStack {
                Text(item.From_Date ?? "")
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
                        Text(item.No_of_Days ?? "-")
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
                }
            }
            .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
        }
    }
}

#Preview {
    LeaveCancelView()
}
