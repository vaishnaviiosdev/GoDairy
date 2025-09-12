
//  MissedPunchApproval.swift
//  GoDairy
//
//  Created by San eforce on 11/09/25.

import SwiftUI

struct MissedPunchApprovalView: View {
    @StateObject var MissedPunchModel = MissedApprovalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                homeBar(frameSize: 40)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    titleCard(title: "MISSED PUNCH APPROVAL", frameHeight: 40, fontSize: 14)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 8)
                
                MissedApprovalHeader()
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(MissedPunchModel.MissedApprovaldata, id: \.Sl_No) { item in
                            MissedApprovalRow(item: item)
                        }
                    }
                }
            }
            .task {
                await MissedPunchModel.fetchMissedApprovalData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MissedApprovalHeader: View {
    var body: some View {
        HStack {
            Text("Name")
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Applied date")
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Click here")
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(colorData.shared.app_backgroundPink)
    }
}

// MARK: - Row View
struct MissedApprovalRow: View {
    let item: missedApprovalDataResponse

    var body: some View {
        HStack {
            Text(item.Sf_name)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(item.AppliedDate)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .center)
            
            NavigationLink(destination: MissedPunchApprovalDetailsView(item: item)) {
                Text("View")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(colorData.shared.appPrimary_Button)
                    .cornerRadius(6)
                }
            .frame(maxWidth: .infinity, alignment: .trailing)

//            Button(action: {
//                print("View tapped for \(item.Sf_name)")
//            }) {
//                Text("View")
//                    .font(.system(size: 13, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(height: 30)
//                    .frame(maxWidth: .infinity)
//                    .background(colorData.shared.appPrimary_Button)
//                    .cornerRadius(6)
//            }
//            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
}

#Preview {
    MissedPunchApprovalView()
}
