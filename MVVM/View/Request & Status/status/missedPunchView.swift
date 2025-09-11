//
//  missedPunchView.swift
//  GoDairy
//
//  Created by San eforce on 08/09/25.
//

import SwiftUI

struct missedPunchView: View {
    
    @StateObject var missedPunchDataResponse = missedPunchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    MissedPunchStatusCard(title: "MISSED PUNCH", missedModel: missedPunchDataResponse)
                }
                .padding(5)
            }
            .task {
                await missedPunchDataResponse.fetchMissedPunchData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MissedPunchStatusCard: View {
    let title: String
    @ObservedObject var missedModel: missedPunchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            MissedPunchStatusList(missedPuchStatusModel: missedModel)
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct MissedPunchStatusList: View {
    @ObservedObject var missedPuchStatusModel: missedPunchViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                LazyVStack(spacing: 20) {
                    ForEach(missedPuchStatusModel.missedPunchData, id: \.id) { item in
                        MissedPunchCardDataList(item: item) // 👈 Your custom card for each row
                    }
                }
            }
            .padding(.vertical, 8)
        }
}

struct MissedPunchCardDataList: View {
    let item: missedPunchModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            topRow
            Divider().background(.gray)
            shiftAndReason
            appliedAndStatus
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 0.3))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 5)
    }
    
    private var topRow: some View {
        HStack {
            Text(item.Missed_punch_date ?? "")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            Text(item.MPStatus ?? "")
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(cssRGB: item.StusClr ?? "") ?? .gray)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
    
    private var shiftAndReason: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            VStack(alignment: .leading, spacing: 2) {
                Text("SHIFT / ONDUTY")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.Shift_Name ?? "")
                    .font(.system(size: 14, weight: .semibold))
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("IN TIME")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(item.Checkin_Time ?? "")")
                        .font(.system(size: 14, weight: .semibold))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("OUT TIME")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(item.Checkout_Tme ?? "")")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("REASON")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.Reason ?? "")
                    .font(.system(size: 14, weight: .semibold))
            }
        }
    }
    
    private var appliedAndStatus: some View {
        HStack {
            Text("Applied: \(item.Submission_date ?? "N/A")")
            Spacer()
            
            // Only show status if Rejectdate is not nil
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
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.gray)
    }
}


//struct MissedPunchCardDataList: View {
//    let item: missedPunchModel
//    
//    var body: some View {
//        // 👇 Break up expressions into variables
//        let missedPunchDate = item.Missed_punch_date
//        //let toDate = item.Submission_date
//        let status = item.MPStatus
//        let statusColor = Color(cssRGB: item.StusClr ?? "") ?? .gray
//        let reason = item.Reason ?? ""
//        let shift = item.Shift_Name ?? ""
//        
//        return VStack(alignment: .leading, spacing: 16) {
//            // Top row
//            HStack {
//                Text("\(missedPunchDate ?? "")")
//                    .font(.system(size: 11, weight: .medium))
//                    .foregroundColor(.black)
//                
//                Spacer()
//                
//                Text(status ?? "")
//                    .font(.system(size: 12, weight: .bold))
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 5)
//                    .background(statusColor)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            
//            Divider().background(.gray)
//            
//            // Shift & Reason
//            VStack(alignment: .leading, spacing: 12) {
//                HStack {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("SHIFT")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        Text(shift)
//                            .font(.system(size: 14, weight: .semibold))
//                    }
//                    
//                    Spacer()
//                    
//                    VStack(alignment: .trailing, spacing: 2) {
//                        Text("FLAG")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        Text("\(item.Missed_punch_Flag ?? "")")
//                            .font(.system(size: 14, weight: .semibold))
//                    }
//                }
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text("REASON")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text(reason)
//                        .font(.system(size: 14, weight: .semibold))
//                }
//            }
//            
//            // Applied & Status date
//            HStack {
//                Text("Applied: \(item.Submission_date ?? "")")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundColor(.gray)
//                
//                Spacer()
//                
//                switch status?.lowercased() {
//                case "approved", "pending":
//                    Text("Approved: \(item.Rejectdate ?? "-")")
//                case "reject":
//                    Text("Rejected: \(item.Rejectdate ?? "-")")
//                default:
//                    Text("Updated: \(item.Rejectdate ?? "-")")
//                }
//            }
//            .font(.system(size: 14, weight: .bold))
//            .foregroundColor(.gray)
//        }
//        .padding(10)
//        .background(
//            RoundedRectangle(cornerRadius: 12).fill(Color.white)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
//        )
//        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//        .padding(.horizontal, 5)
//    }
//}

#Preview {
    missedPunchView()
}
