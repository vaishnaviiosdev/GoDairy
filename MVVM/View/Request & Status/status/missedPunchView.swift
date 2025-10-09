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
                        MissedPunchCardDataList(item: item)
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
//        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
//        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 0.3))
//        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .cardStyle()
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

#Preview {
    missedPunchView()
}
