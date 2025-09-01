//
//  AdvanceRequestView.swift
//  GoDairy
//
//  Created by San eforce on 25/08/25.
//

import SwiftUI

struct AdvanceRequestView: View {
    @State private var selectedAdvanceType: String? = nil
    @State private var enteredLocationStr: String = ""
    @State private var enteredPurposeStr: String = ""
    @State private var numberOfAmount: Double = 0.00
    @State private var activeSelection: AdvanceSelectionType? = nil
    @StateObject var AdvanceModel = AdvanceRequestViewModel()
    
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
                    enteredLocationStr: $enteredLocationStr,
                    enteredPurposeStr: $enteredPurposeStr,
                    numberOfAmount: $numberOfAmount,
                    onAdvanceTypeTap: {
                        activeSelection = .advanceType
                    })
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary) {
                    
                }
                .padding()
            }
            .overlay (
                Group {
                    if let selection = activeSelection {
                        switch selection {
                        case .advanceType:
                            SelectionView (
                                isPresented: Binding(
                                    get: { activeSelection == .advanceType },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: AdvanceModel.advanceTypes,
                                title: "Select Leave Type"
                            ) { selected in
                                selectedAdvanceType = selected
                            }
                        }
                    }
                }
            )
            .task {
                await AdvanceModel.fetchAdvanceTypeData()
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
    @State private var selectedDate: Date? = nil
    @Binding var selectedAdvanceType: String?
    @Binding var enteredLocationStr: String
    @Binding var enteredPurposeStr: String
    @Binding var numberOfAmount: Double
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
            .padding(.top, 5)
            
            CustomTxtfield(title: "Location", placeholderString: "Enter the Location", textValue: $enteredLocationStr)
            
            CustomTxtfield(title: "Purpose", placeholderString: "Enter the Purpose", textValue: $enteredPurposeStr)
            
            DaysView(title: "Enter the Amount", numberOfValue: $numberOfAmount,isEditable: true)
                .padding(.top)
            
            DateCard(title: "Settlement Date", fontWeight: .semibold, placeholder: "Select settlement date", selectedDate: $selectedDate)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct CustomTxtfield: View {
    let title: String
    let placeholderString: String
    @Binding var textValue: String
    var fontWeight: Font.Weight = .light
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView(title: title, fontWeight: .semibold)
            
            ZStack(alignment: .leading) {
                // Custom bold placeholder
                if textValue.isEmpty {
                    Text(placeholderString)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                }
                
                TextField("", text: $textValue)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .font(.system(size: 14))
                    .fontWeight(fontWeight)
            }
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 5)
        }
        .padding(5)
    }
}

#Preview {
    AdvanceRequestView()
}
