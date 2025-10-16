//
//  DeviationStatusView.swift
//  GoDairy
//
//  Created by Naga Prasath on 24/09/25.
//

import SwiftUI

struct DeviationStatusView: View {
    
    @StateObject var deviationStatusVM = DeviationStatusViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    DeviationStatusCard(title: "DEVIATION ENTRY STATUS", DeviationStatusModel: deviationStatusVM)

                }
                .padding(5)
            }
            .task {
                await deviationStatusVM.fetchDeviationStatus()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DeviationStatusCard: View {
    let title: String
    @ObservedObject var DeviationStatusModel: DeviationStatusViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            DeviationStatusList(DeviationStatusModel: DeviationStatusModel)
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct DeviationStatusList: View {
    @ObservedObject var DeviationStatusModel: DeviationStatusViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVStack(spacing: 20) {
                ForEach(DeviationStatusModel.deviationStatusData, id: \.Deviation_Id) { item in
                    DeviationStatusCardView (item: item)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct DeviationStatusCardView: View {
    let item: DeviationStatusModel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            topRow
            Divider().background(.black)
            typeAndReason
            appliedAndStatus
            if item.Rejected_Reason != "" {
                rejectionReason
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 0.3))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 5)
    }
    
    private var topRow: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(item.Deviation_Date)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(item.DStatus)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(cssRGB: item.StusClr) ?? .gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }
    
    private var typeAndReason: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("TYPE")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Amount")
                        .font(.system(size: 14, weight: .regular))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(item.Deviation_Type)
                        .font(.body)
                        .foregroundColor(.black)
                    
                }
            }
        }
    }
    
    private var appliedAndStatus: some View {
        
        HStack {
            Text("Applied: \(item.Created_Date)")
            Spacer()
            
            switch item.Devi_Active_Flag {
            case 0:
                Text("Approved: \(item.LastUpdt_Date)")
            case 1:
                Text("Rejected: \(item.LastUpdt_Date)")
            default:
                Text("Approved: \(item.LastUpdt_Date)")
            }
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.gray)
    }
    
    private var rejectionReason: some View {
        HStack {
            Text("Rejection Reason")
                .font(.caption)
                .foregroundColor(.gray)
            Text(item.Rejected_Reason)
                .font(.system(size: 14, weight: .regular))
        }
    }
}

#Preview {
    DeviationStatusView()
}
