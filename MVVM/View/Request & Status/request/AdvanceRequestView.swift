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
    @State private var FromDate: Date? = nil
    @State private var ToDate: Date? = nil
    @State private var selectedDate: Date? = nil
    @State private var amount = 0.0
    @State private var activeSelection: AdvanceSelectionType? = nil
    @StateObject var AdvanceModel = AdvanceRequestViewModel()
    
    enum AdvanceSelectionType {
        case advanceType
    }
   
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                    .padding(.top,10)
                ScrollView {
                    AdvanceRequestCard(title: "ADVANCE REQUEST",
                    FromDate: $FromDate,
                    ToDate: $ToDate,
                    selectedDate: $selectedDate,
                    selectedAdvanceType: $selectedAdvanceType,
                    enteredLocationStr: $enteredLocationStr,
                    enteredPurposeStr: $enteredPurposeStr,
                                       amount: $amount,
                    onAdvanceTypeTap: {
                        activeSelection = .advanceType
                    })
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary) {
                    Task {
                        await AdvanceModel.PostAdvanceRequestData(
                            Ukey: Ukey,
                            SF: sf_code,
                            eDate: formatDate(Date()),
                            advFrom: formatDate(FromDate ?? Date()),
                            advTo: formatDate(ToDate ?? Date()),
                            advTyp: selectedAdvanceType ?? "",
                            advLoc: enteredLocationStr,
                            advPurp: enteredPurposeStr,
                            advAmt: String(amount),
                            advSettle: formatDate(selectedDate ?? Date())
                        )
                    }
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
            .alert(AdvanceModel.saveSuccessMessage, isPresented: $AdvanceModel.showSaveSuccessAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}

struct AdvanceRequestCard: View {
    let title: String
    @Binding var FromDate: Date?
    @Binding var ToDate: Date?
    @Binding var selectedDate: Date?
    @Binding var selectedAdvanceType: String?
    @Binding var enteredLocationStr: String
    @Binding var enteredPurposeStr: String
    @Binding var amount: Double
    var onAdvanceTypeTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            HStack(spacing: 20) {
                VStack(spacing: 0) {
                    titleView(title: "From Date", fontWeight: .semibold)
                    CustommDatePicker(
                        selectedDate: $FromDate,
                        placeholder: "Select from Date"
                    )
                }
                
                VStack(spacing: 0) {
                    titleView(title: "To Date", fontWeight: .semibold)
                    CustommDatePicker(
                        selectedDate: $ToDate,
                        placeholder: "Select to Date",
                        dateRange: (FromDate != nil ? FromDate!...Date.distantFuture : nil) // 👈 Restrict range
                    )
                    .disabled(FromDate == nil) //Disable until FromDate is selected
                    .opacity(FromDate == nil ? 0.5 : 1.0) // 👈 Dim UI when disabled
                }
            }
            .padding(.horizontal, 8)

            CustomCard(
                title: "Type of Advance",
                placeholderString: "Select the leave type",
                selectedValue: selectedAdvanceType,
                titleFontWeight: .semibold,
                action: onAdvanceTypeTap
            )
            .padding(.top, 5)
            
            CustomTxtfield(title: "Location", placeholderString: "Enter the Location", textValue: $enteredLocationStr)
            
            CustomTxtfield(title: "Purpose", placeholderString: "Enter the Purpose", textValue: $enteredPurposeStr)
            
            DaysView(title: "Enter the Amount", numberOfValue: $amount,isEditable: true)
                .padding(.top)
                        
            VStack(spacing: 0) {
                titleView(title: "Settlement Date",fontWeight: .semibold)
                CustommDatePicker(selectedDate: $selectedDate, placeholder: "Select settlement Date",
                    dateRange: Date()...Date.distantFuture)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct CustommDatePicker: View {
    @Binding var selectedDate: Date?
    @State private var showPicker = false
    
    var placeholder: String = "Select Date"
    var dateRange: ClosedRange<Date>? = nil
    
    var body: some View {
        Button(action: {
            if selectedDate == nil {
                selectedDate = Date() // Ensure it's not nil
            }
            showPicker.toggle()
        }) {
            HStack {
                if let date = selectedDate {
                    Text(date.formattedAsYYYYMMDD())
                        .foregroundColor(.gray)
                        .fontWeight(.regular)
                        .font(.system(size: 14))
                } else {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                Spacer(minLength: 8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    in: dateRange ?? Date.distantPast...Date.distantFuture,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                HStack {
                    Button("Done") {
                        showPicker = false
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimary)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
            }
            .presentationDetents([.medium, .large]) // iOS 16+
        }
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
