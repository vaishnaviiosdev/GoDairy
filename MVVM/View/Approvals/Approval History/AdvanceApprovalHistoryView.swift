//
//  AdvanceApprovalHistoryView.swift
//  GoDairy
//
//  Created by Naga Prasath on 17/09/25.
//

import SwiftUI

struct AdvanceApprovalHistoryView: View {
    
    @StateObject var  advanceApprovalHistoryVM = AdvanceApprovalHistoryViewModel()
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    advanceApprovalStatusCard(title: "", Model: advanceApprovalHistoryVM)
                    
                }
                .padding(5)
            }
            .task {
                await advanceApprovalHistoryVM.fetchAdevanceHistoryData()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct advanceApprovalStatusCard: View {
    let title: String
    @ObservedObject var Model: AdvanceApprovalHistoryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            advanceApprovalStatusList(Model: Model)
            
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct advanceApprovalStatusList: View {
    @ObservedObject var Model: AdvanceApprovalHistoryViewModel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVStack(spacing: 20) {
                
                ForEach(Model.advanceApprovalHistoryList) { item in
                    
                    advanceApprovalCardDataList(item: item)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct advanceApprovalCardDataList: View {
    let item: AdvanceApprovalHistoryModel
    
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
                    Text(item.AdvTyp)
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("AMOUNT")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(item.AdvAmt)")
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("LOCATION")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.AdvLoc)
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("SETTLEMENT DATE")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(item.eDate)")
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 2) {
                Text("PURPOSE")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.AdvPurp)
                    //.font(.system(size: 14, weight: .semibold))
                    .regularTextStyle(size: 14, fontWeight: .semibold)
            }
            
        }
    }
    
    private var appliedAndStatus: some View {
        HStack {
            Text("Applied: \(item.AdvSettle)")
            Spacer()
            
            switch item.flag {
            case 1:
                Text("Approved: \(item.ApprDt)")
            case 2:
                Text("Rejected: \(item.ApprDt)")
            default:
                Text("Updated: \(item.ApprDt)")
            }
        }
        //.font(.system(size: 14, weight: .bold))
        .regularTextStyle(size: 14, foreground: .gray, fontWeight: .bold)
        //.foregroundColor(.gray)
    }
}

#Preview {
    AdvanceApprovalHistoryView()
}
