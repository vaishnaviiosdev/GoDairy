//
//  LeaveCancelApprovalView.swift
//  GoDairy
//
//  Created by Naga Prasath on 23/09/25.
//

import SwiftUI

struct LeaveCancelApprovalView: View {
    
    @StateObject var advanceApprovalVM = PermissionApprovalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                homeBar(frameSize: 40)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    titleCard(title: "LEAVE CANCEL APPROVAL", frameHeight: 40, fontSize: 14)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 8)
                
                ApprovalHeader()
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        
                        ForEach(advanceApprovalVM.permissionApprovaldata) { item in
                            permissionApprovalRow(item: item)
                        }
                    }
                }
            }
            .task {
                await advanceApprovalVM.fetchMissedApprovalData()
            }
        }
    }
}

#Preview {
    LeaveCancelApprovalView()
}
