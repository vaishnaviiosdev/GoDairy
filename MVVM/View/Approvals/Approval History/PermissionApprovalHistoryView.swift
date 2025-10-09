//
//  PermissionApprovalHistoryView.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import SwiftUI

struct PermissionApprovalHistoryView: View {
    
    @StateObject var PermissionApprovalModel = permissionApprovalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    PermissionApprovalStatusCard(title: "PERMISSION STATUS", Model: PermissionApprovalModel)
                }
                .padding(5)
            }
            .task {
                await PermissionApprovalModel.fetchapprovalPermissionData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PermissionApprovalStatusCard: View {
    let title: String
    @ObservedObject var Model: permissionApprovalViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            PermissionApprovalStatusList(Model: Model)
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct PermissionApprovalStatusList: View {
    @ObservedObject var Model: permissionApprovalViewModel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVStack(spacing: 20) {
                ForEach(Model.permissionApprovalData) { item in
                    PermissionApprovalCardDataList(item: item)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct PermissionApprovalCardDataList: View {
    let item: approvalPermissionDataResponse
    
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
                Text(item.Permissiondate)
                    //.font(.system(size: 12, weight: .medium))
                    .regularTextStyle(size: 12, fontWeight: .medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(item.PStatus)
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
                    Text("\(item.FromTime) to \(item.ToTime)")
                        //.font(.system(size: 14, weight: .semibold))
                        .regularTextStyle(size: 14, fontWeight: .semibold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("HOURS")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.Noof_hours)
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
            
            switch item.Approval_Flag {
            case 0:
                Text("Approved: \(item.Approveddate)")
            case 1:
                Text("Rejected: \(item.Approveddate)")
            default:
                Text("Updated: \(item.Approveddate)")
            }
        }
        //.font(.system(size: 14, weight: .bold))
        .regularTextStyle(size: 14, fontWeight: .bold)
        .foregroundColor(.gray)
    }
}

#Preview {
    PermissionApprovalView()
}
