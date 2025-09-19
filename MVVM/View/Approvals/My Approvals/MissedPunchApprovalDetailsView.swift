//
//  MissedPunchApprovalDetailsView.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import SwiftUI

struct MissedPunchApprovalDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    let item: missedApprovalDataResponse
    @StateObject var MissedPunchModel = MissedApprovalViewModel()
    
    var body: some View {
        ApprovalDetailsView(
            title: "MISSED PUNCH APPROVAL",
            rows: [
                ("Name", item.Sf_name),
                ("Emp Code", item.EmpCode),
                ("HQ", item.HQ),
                ("Designation", item.Designation),
                ("Mobile", item.mobilenumber),
                ("Reason", item.Reason),
                ("Applied Date", item.AppliedDate),
                ("Missed Date", item.Missed_punch_date),
                ("Shift/On-duty", item.Shift_Name),
                ("Checkin time", item.Checkin_Tme),
                ("Checkout time", item.Checkout_Tme)
            ],
            onApprove: {
                await MissedPunchModel.PostmissedApprovedData(missedID: item.Sl_No)
                print("Missed Punch Model approved Successfully")
            },
            onReject: { reason in
                await MissedPunchModel.PostmissedRejectData(missedID: item.Sl_No, reason: reason)
                print("The reason is \(reason)")
            }
        )
    }
}

//#Preview {
//    MissedPunchApprovalDetailsView(item: missedApprovalDataResponse)
//}


