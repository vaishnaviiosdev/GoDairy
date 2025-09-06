//
//  LeaveStatusView.swift
//  GoDairy
//
//  Created by San eforce on 06/09/25.
//

import SwiftUI

struct LeaveStatusView: View {
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    LeaveStatusCard(title: "LEAVE STATUS")
                }
                .padding(5)
            }
            .task {
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LeaveStatusCard: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

#Preview {
    LeaveStatusView()
}
