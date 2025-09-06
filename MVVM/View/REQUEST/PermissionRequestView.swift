//
////  PermissionRequestView.swift
////  GoDairy
////
////  Created by San eforce on 02/09/25.
//

import SwiftUI

struct PermissionRequestView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var PermissionDate: Date? = nil
    @State private var selectedPermissionHours: String? = nil
    @State private var selectedShiftTime: String? = nil
    @State private var fromTime: String = ""
    @State private var toTime: String = ""
    @State private var selectedFromTime: String? = nil
    @State private var selectedToTime: String? = nil
    @State private var available: String = ""
    @State private var takenHrs: String = ""
    @State private var currTaken: String = ""
    @State private var permissionReason: String = ""
    @State private var saveSuccessMessage: String = ""
    @State private var activeSelection: PermissionSelectionType? = nil
    @State private var Sft_STime: String = ""
    @State private var sft_ETime: String = ""
    @State private var showToast = false
    @StateObject var permissionModel = PermissionRequestViewModel()
    
    let Hours = ["1", "2"]
    
    enum PermissionSelectionType {
        case permissionHours
        case permissionShiftTime
    }
    
    private func validateForm() -> String? {
        if PermissionDate == nil {
            return "Select Date"
        }
        else if selectedPermissionHours == nil {
            return "Select Hours"
        }
        else if selectedShiftTime == nil {
            return "Select Shift Time"
        }
        else if selectedFromTime == nil || selectedFromTime == "" {
            return "Select From Time"
        }
        else if permissionReason.isEmpty {
            return "Enter Remarks"
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    PermissionRequestCard(
                        title: "PERMISSION REQUEST",
                        PermissionDate: $PermissionDate,
                        selectedPermissionHours: $selectedPermissionHours,
                        selectedShiftTime: $selectedShiftTime,
                        fromTime: $fromTime,
                        toTime: $toTime,
                        selectedFromTime: $selectedFromTime,
                        selectedToTime: $selectedToTime,
                        available: $available,
                        takenHrs: $takenHrs,
                        currTaken: $currTaken,
                        permissionReason: $permissionReason,
                        Sft_STime: $Sft_STime,
                        sft_ETime: $sft_ETime,
                        saveSuccessMessage: $saveSuccessMessage,
                        showToast: $showToast,
                        onPermissionHoursTap: {
                            activeSelection = .permissionHours
                        },
                        onPermissionShiftTimeTap: {
                            if PermissionDate == nil {
                                saveSuccessMessage = "Please select Date first"
                                showToast = true
                            }
                            else {
                                activeSelection = .permissionShiftTime
                            }
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
                            await permissionModel.postPermissionSaveData(
                                pdate: PermissionDate ?? Date(),
                                   startAt: selectedFromTime ?? "",
                                   endAt: selectedToTime ?? "",
                                   reason: permissionReason,
                                   noOfHrs: selectedPermissionHours ?? "")
                            print("✅ Submitting with date: \(String(describing: PermissionDate))")
                        }
                    }
                }
                .padding()
            }
            .overlay (
                Group {
                    if let selection = activeSelection {
                        switch selection {
                        case .permissionHours:
                            SelectionView(
                                isPresented: Binding(
                                    get: { activeSelection == .permissionHours },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: Hours,
                                title: "Select Hours"
                            ) { selected in
                                selectedPermissionHours = selected
                                // ✅ Clear times when hours change
                                selectedFromTime = nil
                                selectedToTime = nil
                            }
                        case .permissionShiftTime:
                            SelectionView(
                                isPresented: Binding(
                                    get: { activeSelection == .permissionShiftTime },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: permissionModel.permissionTypes,
                                title: "Shift Timing"
                            ) { selected in
                                selectedShiftTime = selected
                                selectedFromTime = nil
                                selectedToTime = nil
                                // ✅ Load shift start/end times
                                if let shift = permissionModel.permissionRequestData.first(where: { $0.name == selected }) {
                                    Sft_STime = shift.Sft_STime
                                    sft_ETime = shift.sft_ETime
                                    print("Loaded shift times: \(Sft_STime) - \(sft_ETime)")
                                }
                            }
                        }
                    }
                }
            )
            .task {
                await permissionModel.fetchPermissionShiftTimeData()
                await permissionModel.fetchTakenHrsData()
            }
            .alert(permissionModel.savePermissionSuccessMsg, isPresented: $permissionModel.showPermissionSaveAlert) {
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

struct PermissionRequestCard: View {
    let title: String
    @Binding var PermissionDate: Date?
    @Binding var selectedPermissionHours: String?
    @Binding var selectedShiftTime: String?
    @Binding var fromTime: String
    @Binding var toTime: String
    @Binding var selectedFromTime: String?
    @Binding var selectedToTime: String?
    @Binding var available: String
    @Binding var takenHrs: String
    @Binding var currTaken: String
    @Binding var permissionReason: String
    @Binding var Sft_STime: String
    @Binding var sft_ETime: String
    @Binding var saveSuccessMessage: String
    @Binding var showToast: Bool
    @State private var fromDate: Date? = nil
    
    @State private var availablePermission: Double = 0.0
    @State private var takenHours: Double = 0.0
    @State private var currentTaken: Double = 0.0
    
    var onPermissionHoursTap: () -> Void
    var onPermissionShiftTimeTap: () -> Void
    
    private func formatTimeOnly(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    
    private func timeStringToDate(_ time: String, baseDate: Date) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        guard let parsed = formatter.date(from: time) else { return nil }
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: parsed)
        return calendar.date(bySettingHour: comps.hour ?? 0, minute: comps.minute ?? 0, second: 0, of: baseDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            DateCard(
                title: "Date of Permission",
                placeholder: "Select from Date",
                selectedDate: $PermissionDate,
                selectedTime: $selectedFromTime
            )
            
            CustomCard(
                title: "Select the Hours",
                placeholderString: "Select Hours",
                selectedValue: selectedPermissionHours,
                action: onPermissionHoursTap
            )
            .padding(.top, 5)
            
            CustomCard(
                title: "Shift Time",
                placeholderString: "Shift Timing",
                selectedValue: selectedShiftTime,
                action: onPermissionShiftTimeTap
            )
            .padding(.top, 5)
        
            HStack {
                DateCard(
                    title: "From Time",
                    placeholder: "From Time",
                    selectedDate: $fromDate,
                    selectedTime: $selectedFromTime,
                    pickerMode: .time,
                    onTimeSelected: { selectedDate in
                        // 🔒 Block if no shift time selected
                        guard let shiftName = selectedShiftTime, !shiftName.isEmpty else {
                            saveSuccessMessage = "Please select Shift Time"
                            showToast = true
                            return
                        }
                        
                        guard let permissionDate = PermissionDate else {
                            saveSuccessMessage = "Please select Date first"
                            showToast = true
                            return
                        }
                        
                        // ✅ Normalize selectedDate to permissionDate
                        let calendar = Calendar.current
                        let normalizedSelectedDate = calendar.date(
                            bySettingHour: calendar.component(.hour, from: selectedDate),
                            minute: calendar.component(.minute, from: selectedDate),
                            second: 0,
                            of: permissionDate
                        ) ?? selectedDate
                        
                        guard let shiftStart = timeStringToDate(Sft_STime, baseDate: permissionDate),
                              let shiftEnd = timeStringToDate(sft_ETime, baseDate: permissionDate)
                        else {
                            print("Shift times not ready")
                            return
                        }
                        
                        if normalizedSelectedDate < shiftStart || normalizedSelectedDate > shiftEnd {
                            saveSuccessMessage = "Please select the from time in between the shift time"
                            showToast = true
                            selectedFromTime = nil
                            selectedToTime = nil
                            return
                        }
                        
                        // ✅ Valid time, update From
                        selectedFromTime = formatTimeOnly(normalizedSelectedDate)
                        
                        // ✅ Determine hours to add based on selectedPermissionHours
                        let hoursToAdd = Int(selectedPermissionHours ?? "1") ?? 1
                        if let updatedToTime = calendar.date(byAdding: .hour, value: hoursToAdd, to: normalizedSelectedDate) {
                            selectedToTime = formatTimeOnly(updatedToTime)
                        }
                    }
                )

                VStack(alignment: .leading, spacing: 0) {
                    titleView(title: "To Time")
                    Text(selectedToTime ?? "To Time")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.3))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 10)
                }
            }
            
            titleView(title: "Note:- Kindly use 24 hour time format", fontSize: 11, fontWeight: .light)
                .padding(.horizontal, 8)
            
            HStack {
                DaysView(title: "Available", numberOfValue: $availablePermission, isEditable: false, foregroundColour: Color.red, fontSize: 12)
                DaysView(title: "Taken Hrs", numberOfValue: $takenHours, isEditable: false, foregroundColour: Color.red, fontSize: 12)
                DaysView(title: "Curr.Taken", numberOfValue: $currentTaken, isEditable: false, foregroundColour: Color.red, fontSize: 12)
            }
            .padding(.vertical, 10)
            .padding(.top, 5)
            
            titleView(title: "Reason")
            CustomTextView(text: $permissionReason, placeholder: "Reason")
                .padding(.horizontal, 8)
                .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

#Preview {
    PermissionRequestView()
}
