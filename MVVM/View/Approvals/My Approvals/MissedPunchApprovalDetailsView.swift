//
//  MissedPunchApprovalDetailsView.swift
//  GoDairy
//
//  Created by San eforce on 12/09/25.
//

import SwiftUI

struct MissedPunchApprovalDetailsView: View {
    
    let item: missedApprovalDataResponse
    
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
                .padding(.bottom, 15)
                
                DetailsView(item: item)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DetailsView: View {
    let item: missedApprovalDataResponse
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                detailRow(label: "Name", value: item.Sf_name)
                detailRow(label: "Emp Code", value: item.EmpCode)
                detailRow(label: "HQ", value: item.HQ)
                detailRow(label: "Designation", value: item.Designation)
                detailRow(label: "Mobile", value: item.mobilenumber)
                detailRow(label: "Reason", value: item.Reason)
                detailRow(label: "Applied Date", value: item.AppliedDate)
                detailRow(label: "Missed Date", value: item.Missed_punch_date)
                detailRow(label: "Shift/On-duty", value: item.Shift_Name)
                detailRow(label: "Checkin time", value: item.Checkin_Tme)
                detailRow(label: "Checkout time", value: item.Checkout_Tme)
                
                DetailsBtnView()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func detailRow(label: String, value: String) -> some View {
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

struct DetailsBtnView: View {
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                print("Approve tapped")
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
                print("Reject tapped")
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
        .padding(.top, 5)
    }
}

//#Preview {
//    MissedPunchApprovalDetailsView(item: missedApprovalDataResponse)
//}


