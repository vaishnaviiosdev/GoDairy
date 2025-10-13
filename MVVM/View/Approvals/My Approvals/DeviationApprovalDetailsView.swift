//
//  DeviationApprovalDetailsView.swift
//  GoDairy
//
//  Created by Naga Prasath on 23/09/25.
//

import SwiftUI

struct DeviationApprovalDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var deviationApprovalVM = DeviationEntryApprovalViewModel()
    let item: DeviationEntryApprovalModel
    
    var body: some View {
        ApprovalDetailsView(
            title: "DEVIATION APPROVAL",
            rows: [
                ("Name", item.FieldForceName),
                ("Emp Code", item.EmpCode),
                ("HQ", item.HQ),
                ("Designation", item.Designation),
                ("Mobile", item.SF_Mobile),
                ("Reason", item.Reason),
                ("Deviation Type", item.DeviationName + item.DeviationName + item.DeviationName),
                ("Deviation Date", item.Deviation_Date)
            ],
            onApprove: {
                
                await deviationApprovalVM.saveDeviationApproval(sfCode: item.Sf_Code, deviationId: item.Deviation_Id)
            },
            onReject: { reason in
                await deviationApprovalVM.saveDeviationReject(sfCode: item.Sf_Code, deviationId: item.Deviation_Id, reason: reason)
            })
        
        .alert(deviationApprovalVM.deviationApprovedSuccessMsg, isPresented: $deviationApprovalVM.showDeviationApprovedSaveAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        
        .alert(deviationApprovalVM.deviationRejectSuccessMsg, isPresented: $deviationApprovalVM.showDeviationRejectSaveAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
}

//#Preview {
//    DeviationApprovalDetailsView()
//}
