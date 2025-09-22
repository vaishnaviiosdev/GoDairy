//
//  LeaveApprovalDetailsView.swift
//  GoDairy
//
//  Created by San eforce on 17/09/25.
//

import SwiftUI

struct LeaveApprovalDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var LeaveApprovalModel = LeaveApprovalViewModel()
    let item: leaveApprovalDataResponse
    
    var body: some View {
        ApprovalDetailsView(
            title: "LEAVE APPROVAL",
            rows: [
                ("Name", item.FieldForceName),
                ("Emp Code", item.EmpCode),
                ("HQ", item.HQ),
                ("Designation", item.Designation),
                ("Mobile", item.SF_Mobile),
                ("Reason", item.Reason),
                ("Leave Type", "\(item.Leave_Type)"),
                ("From Date", item.From_Date),
                ("To Date", item.To_Date),
                ("Leave Days", "\(item.LeaveDays)")
            ],
            onApprove: {
                print("The LeaveID is \(item.Leave_Id)")
                await LeaveApprovalModel.PostLeaveApprovedData(
                    FromDate: item.From_Date,
                    ToDate: item.To_Date,
                    no_ofDays: "\(item.LeaveDays)",
                    leave_Id: item.Leave_Id
                )
                print("Leave Approved")
            },
            onReject: { reason in
                print("Leave going to reject")
                await LeaveApprovalModel.PostLeaveRejectData(
                    FromDate: item.From_Date,
                    ToDate: item.To_Date,
                    no_ofDays: "\(item.LeaveDays)",
                    leave_Id: item.Leave_Id,
                    reason: reason)
            }
        )
        .alert(LeaveApprovalModel.leaveApprovedSuccessMsg,
                       isPresented: $LeaveApprovalModel.showLeaveApprovedSaveAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        .alert(LeaveApprovalModel.leaveRejectSuccessMsg,
               isPresented: $LeaveApprovalModel.showLeaveRejectSaveAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
}

//#Preview {
//    LeaveApprovalDetailsView()
//}




