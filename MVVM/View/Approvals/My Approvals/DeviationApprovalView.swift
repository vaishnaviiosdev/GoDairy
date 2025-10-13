//
//  DeviationApprovalView.swift
//  GoDairy
//
//  Created by Naga Prasath on 23/09/25.
//

import SwiftUI

struct DeviationApprovalView: View {
    
    @StateObject var deviationApprovalVM = DeviationEntryApprovalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                homeBar(frameSize: 40)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    titleCard(title: "DEVIATION ENTRY APPROVAL", frameHeight: 40, fontSize: 14)
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 8)
                
                DeviationEntryApprovalHeader()
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(deviationApprovalVM.deviationEntryApprovaldata) { item in
                            DeviationEntryApprovalRow(item: item)
                        }
                    }
                }
            }
            .task {
                await deviationApprovalVM.fetchDeviationEntryApprovalData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DeviationEntryApprovalHeader: View {
    let headers = [
        ("Name", Alignment.leading),
        ("Applied date", Alignment.leading),
        ("Click here", Alignment.trailing)
    ]
    var body: some View {
        HStack {
            ForEach(headers, id: \.0) { title, alignment in
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(colorData.shared.app_backgroundPink)
    }
}

struct DeviationEntryApprovalRow: View {
    let item: DeviationEntryApprovalModel

    var body: some View {
        HStack {
            TextColumn(text: item.FieldForceName, alignment: .leading)
            TextColumn(text: item.Applieddate, alignment: .leading)
            
            
            NavigationLink(destination: DeviationApprovalDetailsView(item: item)) {
                Text("View")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(colorData.shared.appPrimary_Button)
                    .cornerRadius(6)
                }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
}

#Preview {
    DeviationApprovalView()
}
