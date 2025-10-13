//
//  ApprovalMainView.swift
//  GoDairy
//
//  Created by San eforce on 11/09/25.
//

import SwiftUI

struct ApprovalMainView: View {
    
    private let myApprovalItems: [(title: String, destination: AnyView)] = [
        ("Advance Request", AnyView(PermissionApprovalView())),
        ("Leave", AnyView(LeaveApprovalView())),
        ("Leave Cancel", AnyView(forgetpass())),
        ("Permission", AnyView(PermissionApprovalView())),
        ("Missed Punch", AnyView(MissedPunchApprovalView())),
        ("Travel Allowance", AnyView(forgetpass())),
        ("Work Plan-PJP", AnyView(GeoTaggingView())),
        ("Deviation Entry", AnyView(DeviationApprovalView()))
    ]
    
    private let approvalHistoryItems: [(title: String, destination: AnyView)] = [

        ("Advance Request",AnyView(AdvanceApprovalHistoryView())),
        ("Leave",AnyView(LeaveApprovalHistoryView())),

        ("Permission",AnyView(PermissionApprovalHistoryView())),
        ("Missed Punch",AnyView(MissedPunchApprovalHistoryView())),
        ("Travel Allowance",AnyView(forgetpass())),
        ("Leave Cancel",AnyView(LeaveCancelApprovalHistoryView()))
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

//For Approve & Reject Reusable
// MARK: - Shared Row View
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .foregroundColor(.green)
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Shared Buttons View
struct ApprovalButtons: View {
    var approveAction: () async -> Void
    var rejectAction: (_ reason: String) async -> Void
    
    @State private var showRejectReason = false
    @State private var reasonText = ""
    @Binding var showToast: Bool
    @Binding var saveSuccessMessage: String
    
    var body: some View {
        VStack(spacing: 10) {
            if showRejectReason {
                VStack(alignment: .leading, spacing: 8) {
                    
                    titleView(title: "Reason", fontWeight: .bold)
                    CustomTextView(text: $reasonText, placeholder: "Reason for leave")
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                if let errorMessage = validateForm() {
                                    saveSuccessMessage = errorMessage
                                    showToast = true
                                }
                                else {
                                    await rejectAction(reasonText)
                                    showRejectReason = false
                                    reasonText = ""
                                }
                            }
                        }) {
                            Text("SAVE")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(colorData.shared.appPrimary_Button)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                }
            }
            else {
                HStack(spacing: 10) {
                    Button(action: {
                        Task { await approveAction() }
                    }) {
                        Text("APPROVE")
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colorData.shared.acceptBtn)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        withAnimation {
                            showRejectReason = true
                        }
                    }) {
                        Text("REJECT")
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colorData.shared.rejectBtn)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.top, 5)
        .animation(.easeInOut, value: showRejectReason)
    }
    
    private func validateForm() -> String? {
        if reasonText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter the Reason"
        }
        return nil
    }
}

// MARK: - Save Button
struct SaveButton: View {
    var title: String = "SAVE"
    var action: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(colorData.shared.appPrimary_Button)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
    }
}

// MARK: - Generic Approval Details Screen
struct ApprovalDetailsView: View {
    @State var textValue: String = ""
    let title: String
    let rows: [(label: String, value: String)]
    let onApprove: () async -> Void
    let onReject: (_ reason: String) async -> Void
    @State private var showToast = false
    @State private var saveSuccessMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                homeBar(frameSize: 40)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    titleCard(title: title, frameHeight: 40, fontSize: 14)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 8)
                .padding(.bottom, 15)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(rows, id: \.label) { row in
                            DetailRow(label: row.label, value: row.value)
                        }
                        ApprovalButtons(
                            approveAction: onApprove,
                            rejectAction: onReject,
                            showToast: $showToast,
                            saveSuccessMessage: $saveSuccessMessage
                        )
                    }
                    .padding()
                }
            }
            .overlay(
                VStack {
                    if showToast {
                        ToastView(message: saveSuccessMessage)
                            .padding(.bottom, 60)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { showToast = false }
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ApprovalMainView()
}
