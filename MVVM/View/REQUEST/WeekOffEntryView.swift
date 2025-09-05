//
//  WeekOffEntryView.swift
//  GoDairy
//
//  Created by San eforce on 05/09/25.
//

import SwiftUI

struct WeekOffEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var SelectedWeekOffEntryDate: Date? = nil
    @State private var selectedFromTime: String? = nil
    @State private var activeSelection: WeekOffSelectionType? = nil
    @State private var saveSuccessMessage: String = ""
    @State private var showToast = false
    @State private var reason: String = ""
    
    @StateObject var weekOffModel = WeeklyOffViewModel()
    
    enum WeekOffSelectionType {
        case WeekOffDate
    }
    
    private func validateForm() -> String? {
        if SelectedWeekOffEntryDate == nil {
            return "Select Date"
        }
        else if reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter Remarks"
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    WeekOffEntryCard(title: "WEEKOFF ENTRY", SelectedWeekOffEntryDate: $SelectedWeekOffEntryDate, selectedFromTime: $selectedFromTime,
                        reason: $reason,
                        onPunchDateTap: {
                        activeSelection = .WeekOffDate
                    })
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary) {
                    Task {
                        if let errorMessage = validateForm() {
                            saveSuccessMessage = errorMessage
                            showToast = true
                        }
                        else {
                            await weekOffModel.postWeekOffEntry(weekDate: SelectedWeekOffEntryDate ?? Date(), reason: reason)
                        }
                    }
                }
                .padding()
            }
            .task {
                
            }
            .alert(weekOffModel.saveWeeklyOffSuccessMsg, isPresented: $weekOffModel.showWeeklyOffSaveAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(
            VStack {
                if showToast {
                    ToastView(message: saveSuccessMessage)
                        .padding(.bottom, 60)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        )
    }
}

struct WeekOffEntryCard: View {
    let title: String
    @Binding var SelectedWeekOffEntryDate: Date?
    @Binding var selectedFromTime: String?
    @Binding var reason: String
    
    var onPunchDateTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            DateCard(
                title: "Date of Permission",
                placeholder: "Select from Date",
                selectedDate: $SelectedWeekOffEntryDate,
                selectedTime: $selectedFromTime
            )
            
            titleView(title: "Remarks")
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
    WeekOffEntryView()
}
