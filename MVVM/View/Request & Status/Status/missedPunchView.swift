////
////  missedPunchView.swift
////  GoDairy
////
////  Created by San eforce on 08/09/25.
////
//
import SwiftUI
//
//struct missedPunchView: View {
//    
//    @StateObject var missedPunchDataResponse = missedPunchViewModel()
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                homeBar(frameSize: 40)
//                ScrollView {
//                    MissedPunchStatusCard(title: "MISSED PUNCH", missedModel: missedPunchDataResponse)
//                }
//                .padding(5)
//            }
//            .task {
//                await missedPunchDataResponse.fetchMissedPunchData()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct MissedPunchStatusCard: View {
//    let title: String
//    @ObservedObject var missedModel: missedPunchViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            titleCard(title: title, frameHeight: 40, fontSize: 14)
//            
//            MissedPunchStatusList(missedPuchStatusModel: missedModel)
//        }
//        .background(Color.backgroundColour)
//        .cornerRadius(12)
//        .padding(.horizontal, 8)
//    }
//}
//
//struct MissedPunchStatusList: View {
//    @ObservedObject var missedPuchStatusModel: missedPunchViewModel
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 10) {
//                LazyVStack(spacing: 20) {
//                    ForEach(missedPuchStatusModel.missedPunchData, id: \.id) { item in
//                        MissedPunchCardDataList(item: item)
//                    }
//                }
//            }
//            .padding(.vertical, 8)
//        }
//}
//
//struct MissedPunchCardDataList: View {
//    let item: missedPunchModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            topRow
//            Divider().background(.gray)
//            shiftAndReason
//            appliedAndStatus
//        }
//        .padding(10)
//        .cardStyle()
//        .padding(.horizontal, 5)
//    }
//    
//    private var topRow: some View {
//        HStack {
//            Text(item.Missed_punch_date ?? "")
//                .regularTextStyle(size: 12, foreground: .black, fontWeight: .medium)
//            
//            Spacer()
//            
//            Text(item.MPStatus ?? "")
//                .regularTextStyle(size: 14, foreground: .white, fontWeight: .bold)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 5)
//                .background(Color(cssRGB: item.StusClr ?? "") ?? .gray)
//                .cornerRadius(12)
//        }
//    }
//    
//    private var shiftAndReason: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text("SHIFT / ONDUTY")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text(item.Shift_Name ?? "")
//                    .regularTextStyle(size: 14, fontWeight: .semibold)
//            }
//            HStack {
//                VStack(alignment: .leading, spacing: 2) {
//                    Text("IN TIME")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text("\(item.Checkin_Time ?? "")")
//                        .regularTextStyle(size: 14, fontWeight: .semibold)
//                }
//                Spacer()
//                VStack(alignment: .trailing, spacing: 2) {
//                    Text("OUT TIME")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text("\(item.Checkout_Tme ?? "")")
//                        .regularTextStyle(size: 14, fontWeight: .semibold)
//                }
//            }
//            VStack(alignment: .leading, spacing: 2) {
//                Text("REASON")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text(item.Reason ?? "")
//                    .regularTextStyle(size: 14, fontWeight: .semibold)
//            }
//        }
//    }
//    
//    private var appliedAndStatus: some View {
//        HStack {
//            Text("Applied: \(item.Submission_date ?? "N/A")")
//            Spacer()
//            
//            if let rejectDate = item.Rejectdate, !rejectDate.isEmpty {
//                switch item.MPStatus?.lowercased() {
//                case "approved", "pending":
//                    Text("Approved: \(rejectDate)")
//                case "reject":
//                    Text("Rejected: \(rejectDate)")
//                default:
//                    Text("Updated: \(rejectDate)")
//                }
//            }
//        }
//        .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
//    }
//}
//


struct missedPunchView: View {
    @StateObject private var viewModel = missedPunchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    StatusSection(title: "MISSED PUNCH") {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.missedPunchData, id: \.id) { item in
                                MissedPunchStatusCard(item: item)
                            }
                        }
                    }
                }
                .padding(5)
            }
            .task { await viewModel.fetchMissedPunchData() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MissedPunchStatusCard: View {
    let item: missedPunchModel
    
    var body: some View {
        StatusBaseCard {
            HStack {
                Text(item.Missed_punch_date ?? "")
                    .regularTextStyle(size: 13, foreground: .black, fontWeight: .regular)
                Spacer()
                Text(item.MPStatus ?? "")
                    .regularTextStyle(size: 14, foreground: .white, fontWeight: .bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(cssRGB: item.StusClr ?? "") ?? .gray)
                    .cornerRadius(12)
            }
            
            Divider().background(.gray)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading) {
                    Text("SHIFT / ONDUTY")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        //.fontWeight(.medium)
                    Text(item.Shift_Name ?? "")
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("IN TIME").font(.caption).foregroundColor(.gray)
                        Text(item.Checkin_Time ?? "")
                            .regularTextStyle(size: 14, fontWeight: .semibold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("OUT TIME").font(.caption).foregroundColor(.gray)
                        Text(item.Checkout_Tme ?? "")
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
                Text("Applied: \(item.Submission_date ?? "N/A")")
                Spacer()
                if let rejectDate = item.Rejectdate, !rejectDate.isEmpty {
                    switch item.MPStatus?.lowercased() {
                    case "approved", "pending":
                        Text("Approved: \(rejectDate)")
                    case "reject":
                        Text("Rejected: \(rejectDate)")
                    default:
                        Text("Updated: \(rejectDate)")
                    }
                }
            }
            .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
        }
    }
}


#Preview {
    missedPunchView()
}

