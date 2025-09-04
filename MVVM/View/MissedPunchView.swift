//
//  MissedPunchView.swift
//  GoDairy
//
//  Created by San eforce on 04/09/25.
//

import SwiftUI

struct MissedPunchView: View {
    
    @State private var SelectedmissedPunchDate: String? = nil
    @State private var shiftTime: String = ""
    @State private var checkInTime: String = ""
    @State private var checkOutTime: String = ""
    @State private var reason: String = ""
    @State private var activeSelection: MissedSelectionType? = nil
    @State private var saveSuccessMessage: String = ""
    @State private var showToast = false
    
    @StateObject var missedModel = MissedPunchViewModel()
    
    enum MissedSelectionType {
        case missedType
    }
    
    private func cleanBrackets(from text: String) -> String {
        return text
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func validateForm() -> String? {
        if SelectedmissedPunchDate == nil || SelectedmissedPunchDate == "" {
            return "Select Date"
        }
        else if reason == "" {
            return "Enter Remarks"
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    MissedPunchCard(
                        title: "MISSED PUNCH ENTRY",
                        SelectedmissedPunchDate: $SelectedmissedPunchDate,
                        shiftTime: $shiftTime,
                        checkInTime: $checkInTime,
                        checkOutTime: $checkOutTime,
                        reason: $reason,
                        onPunchDateTap: {
                            activeSelection = .missedType
                        }
                    )
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary) {
                    Task {
                        if let errorMessage = validateForm() {
                            saveSuccessMessage = errorMessage
                            showToast = true
                        }
                        else {
                            await missedModel.postMissedPunchEntry(missedDate: SelectedmissedPunchDate ?? "", shiftName: shiftTime, checkoutTime: checkOutTime, checkinTime: checkInTime, reason: reason)
                        }
                    }
                }
                .padding()
            }
            .overlay (
                Group {
                    if let selection = activeSelection {
                        switch selection {
                        case .missedType:
                            SelectionView(
                                isPresented: Binding(
                                    get: { activeSelection == .missedType },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: missedModel.missedTypes,
                                title: "Select Missed Date"
                            ) { selected in
                                if let selectedData = missedModel.missedPunchResponse.first(where: {
                                    cleanBrackets(from: $0.name1) == selected
                                }) {
                                    SelectedmissedPunchDate = selectedData.name
                                    shiftTime = cleanBrackets(from: selectedData.name1)
                                    checkInTime = selectedData.checkinTime
                                    checkOutTime = selectedData.checkoutTime
                                }
                            }

                        }
                    }
                }
            )
            .task {
                await missedModel.fetchMissedPunchData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MissedPunchCard: View {
    let title: String
    @Binding var SelectedmissedPunchDate: String?
    @Binding var shiftTime: String
    @Binding var checkInTime: String
    @Binding var checkOutTime: String
    @Binding var reason: String
    //@Binding var selectedPermissionHours: String?
    
    var onPunchDateTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            CustomCard(
                title: "Missed Punch Date",
                placeholderString: "Select Missed Date",
                selectedValue: SelectedmissedPunchDate,
                action: onPunchDateTap
            )
            
            CustomCard( // 🔹 Shift Time (Read-only)
                title: "Shift Time",
                placeholderString: "No Shift Time",
                selectedValue: shiftTime,
                action: {}
            )
                        
            CustomCard( // 🔹 Check-in Time (Read-only)
                title: "Check-in Time",
                placeholderString: "No Check-in Time",
                selectedValue: checkInTime,
                action: {}
            )
            
            CustomCard( // 🔹 Check-Out Time (Read-only)
                title: "Check-out Time",
                placeholderString: "No Check-out Time",
                selectedValue: checkOutTime,
                action: {}
            )
            
            titleView(title: "Reason")
                .padding(.horizontal, 5)
            CustomTextView(text: $reason, placeholder: "Reason")
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

#Preview {
    MissedPunchView()
}
