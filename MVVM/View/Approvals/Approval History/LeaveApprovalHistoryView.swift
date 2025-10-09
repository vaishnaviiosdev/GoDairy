//
//  LeaveApprovalHistoryView.swift
//  GoDairy
//
//  Created by Naga Prasath on 17/09/25.
//

import SwiftUI

struct LeaveApprovalHistoryView: View {
    
    @StateObject var leaveApprovalHistoryVM = LeaveApprovalHistoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    leaveApprovalStatusCard(title: "Leave", Model: leaveApprovalHistoryVM)
                    
                    //missedPunchApprovalStatusCard(title: "MISSED PUNCH", Model: leaveApprovalHistoryVM)
                }
                .padding(5)
            }
            .task {
                await leaveApprovalHistoryVM.fetchLeaveHistoryData()
            }
        }
        .navigationBarBackButtonHidden()
    }
}


struct leaveApprovalStatusCard: View {
    let title: String
    @ObservedObject var Model: LeaveApprovalHistoryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            leaveApprovalStatusList(Model: Model)
            
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct leaveApprovalStatusList: View {
    @ObservedObject var Model: LeaveApprovalHistoryViewModel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVStack(spacing: 20) {
                
                ForEach(Model.leaveApprovalHistoryList) { item in
                    
                    LeaveApprovalCardDataList(item: item)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct LeaveApprovalCardDataList: View {
    let item: LeaveApprovalHistoryModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            topRow
            Divider().background(.black)
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
        VStack(alignment: .leading) {
            Text(item.SFNm)
                //.font(.system(size: 11, weight: .semibold))
                .regularTextStyle(size: 11, fontWeight: .semibold)
                .foregroundColor(Color(cssRGB: item.StusClr) ?? .gray)
            
            HStack {
                Text(item.From_Date + " TO " + item.To_Date)
                    //.font(.system(size: 12, weight: .medium))
                    .regularTextStyle(size: 12, fontWeight: .medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(item.LStatus)
                    //.font(.system(size: 12, weight: .bold))
                    .regularTextStyle(size: 12, fontWeight: .bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(cssRGB: item.StusClr) ?? .gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }
    
    private var shiftAndReason: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("TYPE")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.Leave_Type)
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("DAYS")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(item.No_of_Days)")
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 2) {
                Text("REASON")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.Reason)
                    //.font(.system(size: 14, weight: .semibold))
                    .regularTextStyle(size: 14, fontWeight: .semibold)
            }
        }
    }
    
    private var appliedAndStatus: some View {
        HStack {
            Text("Applied: \(item.Created_Date)")
            Spacer()
            
            switch item.Leave_Active_Flag {
            case "0":
                Text("Approved: \(item.LastUpdt_Date)")
            case "1":
                Text("Rejected: \(item.LastUpdt_Date)")
            default:
                Text("Updated: \(item.LastUpdt_Date)")
            }
        }
        //.font(.system(size: 14, weight: .bold))
        .regularTextStyle(size: 14, fontWeight: .bold)
        .foregroundColor(.gray)
    }
}

#Preview {
    LeaveApprovalHistoryView()
}
