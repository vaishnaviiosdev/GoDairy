//
//  LeaveApprovalView.swift
//  GoDairy
//
//  Created by San eforce on 17/09/25.
//

import SwiftUI

struct LeaveApprovalView: View {
    @StateObject var LeaveApprovalModel = LeaveApprovalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                homeBar(frameSize: 40)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    titleCard(title: "LEAVE APPROVAL", frameHeight: 40, fontSize: 14)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 8)
                
                LeaveApprovalHeader()
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(LeaveApprovalModel.leaveApprovalData) { item in
                            LeaveApprovalRow(item: item)
                        }
                    }
                }
            }
            .task {
                await LeaveApprovalModel.fetchLeaveApprovalData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LeaveApprovalHeader: View {
    let headers = [
        ("Name", Alignment.leading),
        ("Applied date", Alignment.leading),
        ("Leave Days", Alignment.trailing),
        ("Click here", Alignment.trailing)
    ]
    var body: some View {
        HStack {
            ForEach(headers, id: \.0) { title, alignment in
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(colorData.shared.app_backgroundPink)
    }
}

struct LeaveApprovalRow: View {
    let item: leaveApprovalDataResponse

    var body: some View {
        HStack {
            TextColumn(text: item.FieldForceName, alignment: .leading)
            TextColumn(text: item.Applieddate, alignment: .leading)
            TextColumn(text: "\(item.LeaveDays)", alignment: .center)
            
            NavigationLink(destination: LeaveApprovalDetailsView(item: item)) {
                Text("View")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(colorData.shared.appPrimary_Button)
                    .cornerRadius(6)
                }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
}

struct TextColumn: View {
    let text: String
    let alignment: Alignment

    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(.gray)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

#Preview {
    LeaveApprovalView()
}
