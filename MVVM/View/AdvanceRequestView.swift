//
//  AdvanceRequestView.swift
//  GoDairy
//
//  Created by San eforce on 25/08/25.
//

import SwiftUI

struct AdvanceRequestView: View {
    
    @State private var selectedAdvanceType: String? = nil
    
    @State private var activeSelection: AdvanceSelectionType? = nil
    
    enum AdvanceSelectionType {
        case advanceType
    }
   
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    AdvanceRequestCard(title: "ADVANCE REQUEST",
                    selectedAdvanceType: $selectedAdvanceType,
                    onAdvanceTypeTap: {
                        activeSelection = .advanceType
                    }
                    )
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary1) {
                    
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}

struct AdvanceRequestCard: View {
    let title: String
    
    @State private var FromDate: Date? = nil
    @State private var ToDate: Date? = nil
    @Binding var selectedAdvanceType: String?
    var onAdvanceTypeTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            HStack {
                DateCard(title: "From Date", fontWeight: .semibold, placeholder: "Select from Date", selectedDate: $FromDate)
                    
                DateCard(title: "To Date",fontWeight: .semibold, placeholder: "Select To Date", selectedDate: $ToDate)
            }
            
            CustomCard(
                title: "Type of Advance",
                placeholderString: "Select the leave type",
                selectedValue: selectedAdvanceType,
                action: onAdvanceTypeTap
            )
            
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

#Preview {
    AdvanceRequestView()
}
