//
//  ApprovalMainView.swift
//  GoDairy
//
//  Created by San eforce on 11/09/25.
//

import SwiftUI

struct ApprovalMainView: View {
    
    private let myApprovalItems: [(title: String, destination: AnyView)] = [
        ("Advance Request", AnyView(AdvanceRequestView())),
        ("Leave", AnyView(LeaveRequestView())),
        ("Leave Cancel", AnyView(LeaveRequestView())),
        ("Permission", AnyView(PermissionRequestView())),
        ("Missed Punch", AnyView(MissedPunchApproval())),
        ("Travel Allowance", AnyView(weeklyOffView())),
        ("Work Plan-PJP", AnyView(weeklyOffView())),
        ("Deviation Entry", AnyView(DeviationEntryView()))
    ]
    
    private let approvalHistoryItems: [(title: String, destination: AnyView)] = [
        ("Advance Request",AnyView(LeaveStatusView())),
        ("Leave",AnyView(LeaveStatusView())),
        ("Permission",AnyView(LeaveStatusView())),
        ("Missed Punch",AnyView(missedPunchView())),
        ("Travel Allowance",AnyView(weeklyOffView())),
        ("Leave Cancel",AnyView(LeaveCancelView()))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar()
            ScrollView {
                VStack(spacing: 16) {
                    SectionCard(title: "MY APPROVALS", items: myApprovalItems)
                   
                    SectionCard(title: "APPROVAL HISTORY", items: approvalHistoryItems)
                }
                .padding(.vertical, 8)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
            }
        }
        .ignoresSafeArea(.all)
        .navigationTitle("")
    }
}

#Preview {
    ApprovalMainView()
}
