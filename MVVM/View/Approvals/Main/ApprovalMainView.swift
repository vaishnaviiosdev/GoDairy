//
//  ApprovalMainView.swift
//  GoDairy
//
//  Created by San eforce on 11/09/25.
//

import SwiftUI

struct ApprovalMainView: View {
    
    private let myApprovalItems: [(title: String, destination: AnyView)] = [
        ("Advance Request", AnyView(forgetpass())),
        ("Leave", AnyView(LeaveApprovalView())),
        ("Leave Cancel", AnyView(forgetpass())),
        ("Permission", AnyView(forgetpass())),
        ("Missed Punch", AnyView(MissedPunchApprovalView())),
        ("Travel Allowance", AnyView(forgetpass())),
        ("Work Plan-PJP", AnyView(forgetpass())),
        ("Deviation Entry", AnyView(forgetpass()))
    ]
    
    private let approvalHistoryItems: [(title: String, destination: AnyView)] = [

        ("Advance Request",AnyView(LeaveStatusView())),
        ("Leave",AnyView(LeaveApprovalHistoryView())),

        ("Permission",AnyView(PermissionApprovalView())),
        ("Missed Punch",AnyView(MissedPunchApprovalHistoryView())),
        ("Travel Allowance",AnyView(forgetpass())),
        ("Leave Cancel",AnyView(forgetpass()))
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
