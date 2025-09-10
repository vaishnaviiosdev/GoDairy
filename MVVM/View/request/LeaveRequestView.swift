//
//  LeaveView.swift
//  GoDairy
//
//  Created by San eforce on 25/08/25.
//

import SwiftUI

struct LeaveRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLeaveType: String? = nil
    @State private var FromDate: Date? = nil
    @State private var ToDate: Date? = nil
    @State private var selectedShiftTiming: String? = nil
    @State private var selectedTypeOfHalfDay: String? = nil
    @State private var activeSelection: SelectionType? = nil
    @State private var selectedLeaveCode: String? = nil
    @State private var textValue = ""
    @State private var selectedLeaveList: LeaveTypeSelection? = nil
    @State private var saveSuccessMessage: String = ""
    @State private var numberOfDays: Double = 0.0
    @State private var showToast = false
    @StateObject var LeaveModel = LeaveRequestViewModel()
    
    let halfDayTYpe = ["First Half", "Second Half"]
    
    enum SelectionType {
        case leaveType
        case shiftTiming
        case halfDay
    }
    
    struct LeaveTypeSelection {
        let id: Int
        let name: String
        let shortName: String
    }
        
    private func validateForm() -> String? {
        if selectedLeaveType == nil { return "Enter Leave Type" }
        if FromDate == nil { return "Enter From Date" }
        if ToDate == nil { return "Enter To Date" }
        if textValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Enter Remarks" }
        
        calculateNumberOfDays()
        
        if let code = selectedLeaveCode,
           let leave = LeaveModel.LeaveRequestData.first(where: { $0.LeaveCode == code }) {
            if numberOfDays > leave.LeaveAvailability {
                return "Leave days exceed available days (\(Int(leave.LeaveAvailability)))"
            }
        }
        return nil
    }
    
    private func calculateNumberOfDays() {
        guard let start = FromDate, let end = ToDate else {
            numberOfDays = 0
            return
        }
        
        if selectedTypeOfHalfDay != nil && areDatesSameDay(start, end) {
            numberOfDays = 0.5
        } else {
            let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
            numberOfDays = Double(max(days + 1, 0))
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    LeaveSectionCard(
                        title: "LEAVE REQUEST",
                        selectedLeaveType: $selectedLeaveType,
                        FromDate: $FromDate,
                        ToDate: $ToDate,
                        textValue: $textValue,
                        selectedShiftTiming: $selectedShiftTiming,
                        selectedTypeOfHalfDay: $selectedTypeOfHalfDay,
                        selectedLeaveCode: $selectedLeaveCode,
                        numberOfDays: $numberOfDays,
                        LeaveModel: LeaveModel,
                        onLeaveTypeTap: {
                            activeSelection = .leaveType
                        },
                        onShiftTimingTap: {
                            activeSelection = .shiftTiming
                        },
                        onHalfDayTap: {
                            activeSelection = .halfDay
                        },
                        showToast: $showToast,
                        toastMessage: $saveSuccessMessage
                    )
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary1) {
                    Task {
                        if let errorMessage = validateForm() {
                            saveSuccessMessage = errorMessage
                            showToast = true
                        } else {
                            await LeaveModel.saveProducts(
                                leave_Type: selectedLeaveList?.shortName ?? "",
                                from_Date: FromDate ?? Date(),
                                to_Date: ToDate ?? Date(),
                                halfDay: selectedTypeOfHalfDay ?? "",
                                selectedHalfDayType: selectedTypeOfHalfDay ?? "",
                                selectedShiftTime: selectedShiftTiming ?? ""
                            )
                        }
                    }
                }
                .padding()
            }
            .overlay(
                Group {
                    if let selection = activeSelection {
                        switch selection {
                        case .leaveType:
                            SelectionView (
                                isPresented: Binding(
                                    get: { activeSelection == .leaveType },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: LeaveModel.LeaveTypeName,
                                title: "Select Leave Type"
                            ) { selected in
                                selectedLeaveType = selected
                                if let found = LeaveModel.LeaveTypeData.first(where: { $0.name == selected }) {
                                    selectedLeaveList = LeaveTypeSelection(
                                        id: found.id,
                                        name: found.name,
                                        shortName: found.Leave_SName
                                    )
                                }
                            }
                        case .shiftTiming:
                            SelectionView (
                                isPresented: Binding(
                                    get: { activeSelection == .shiftTiming },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: LeaveModel.shiftTimes,
                                title: "Shift Timing"
                            ) { selected in
                                selectedShiftTiming = selected
                            }
                        case .halfDay:
                            SelectionView (
                                isPresented: Binding(
                                    get: { activeSelection == .halfDay },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: halfDayTYpe,
                                title: "Halfday Type"
                            ) { selected in
                                selectedTypeOfHalfDay = selected
                            }
                        }
                    }
                }
            )
            .task {
                await LeaveModel.fetchLeaveTypeData()
                await LeaveModel.fetchLeaveAvailabilityData()
                await LeaveModel.fetchShiftTimeData()
                
                if let firstLeave = LeaveModel.LeaveRequestData.first {
                        selectedLeaveCode = firstLeave.LeaveCode
                }
            }
            .alert(LeaveModel.LeaveRequestSuccessMsg, isPresented: $LeaveModel.LeaveRequestSaveAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
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

// MARK: - Custom Date Picker Sheet
struct DatePickerSheet: View {
    let title: String
    @Binding var date: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            
            Button("Done") {
                isPresented = false
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}

struct LeaveSectionCard: View {
    let title: String
    @Binding var selectedLeaveType: String?
    @Binding var FromDate: Date?
    @Binding var ToDate: Date?
    @Binding var textValue: String
    @Binding var selectedShiftTiming: String?
    @Binding var selectedTypeOfHalfDay: String?
    @Binding var selectedLeaveCode: String?
    @Binding var numberOfDays: Double
    @ObservedObject var LeaveModel: LeaveRequestViewModel

    var onLeaveTypeTap: () -> Void
    var onShiftTimingTap: () -> Void
    var onHalfDayTap: () -> Void
    
    @State private var selectedTime: String? = nil
    @State private var isFromDatePickerPresented = false
    @State private var isToDatePickerPresented = false
    @State private var isHalfDaySelected = false
    @Binding var showToast: Bool
    @Binding var toastMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            CustomCard(
                title: "Type of Leave",
                placeholderString: "Select the leave type",
                selectedValue: selectedLeaveType,
                action: onLeaveTypeTap
            )
                        
            HStack(spacing: 20) {
                VStack(spacing: 0) {
                    titleView(title: "From Date")
                    CustommDatePicker(
                        selectedDate: $FromDate,
                        placeholder: "Select from Date"
                    )
                }
                
                VStack(spacing: 0) {
                    titleView(title: "To Date")
                    CustommDatePicker(
                        selectedDate: $ToDate,
                        placeholder: "Select to Date",
                        dateRange: (FromDate != nil ? FromDate!...Date.distantFuture : nil) // 👈 Restrict range
                    )
                    .disabled(FromDate == nil)
                }
            }
            .padding(.horizontal, 8)
            .onChange(of: FromDate) { _ in
                calculateNumberOfDays()
            }
            .onChange(of: ToDate) { _ in
                calculateNumberOfDays()
            }
            .onChange(of: isHalfDaySelected) { _ in
                calculateNumberOfDays()
            }
            
            HStack {
                DaysView(title: "No of days", numberOfValue: $numberOfDays, isEditable: false)
                if areDatesSameDay(FromDate, ToDate) {
                    halfdayView(isHalfDaySelected: $isHalfDaySelected)
                }
            }
            .padding(.vertical, 10)
            .padding(.top, 5)
            
            if isHalfDaySelected && areDatesSameDay(FromDate, ToDate) {
                CustomCard(title: "Shift Timing", placeholderString: "Shift Timing",selectedValue: selectedShiftTiming, action: onShiftTimingTap)
                CustomCard(title: "Type of Half-Day", placeholderString: "Halfday Type",selectedValue: selectedTypeOfHalfDay, action: onHalfDayTap)
            }
            
            titleView(title: "Reason for leave:")
            CustomTextView(text: $textValue, placeholder: "Reason for leave")
                .padding(.horizontal, 8)
                .padding(.bottom, 10)
            
            LeaveAvailabilityList(LeaveModel: LeaveModel, selectedLeaveCode: $selectedLeaveCode)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
    
    func calculateNumberOfDays() {
        guard let start = FromDate, let end = ToDate else {
            numberOfDays = 0
            return
        }

        if isHalfDaySelected && areDatesSameDay(start, end) {
            numberOfDays = 0.5
        }
        else {
            let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
            numberOfDays = Double(max(days + 1, 0)) // include start date
        }

        print("selectedLeaveCode:", selectedLeaveCode ?? "nil")
        print("LeaveRequestData codes:", LeaveModel.LeaveRequestData.map { $0.LeaveCode })

        // Check leave availability
        if let code = selectedLeaveCode,
           let leave = LeaveModel.LeaveRequestData.first(where: { $0.LeaveCode == code }) {

            if numberOfDays > leave.LeaveAvailability {
                toastMessage = "Leave days exceed available days"
                showToast = true

                // Optional: reset after 2 seconds (after toast disappears)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    FromDate = nil
                    ToDate = nil
                    numberOfDays = 0
                }
            }
            else {
                print("Leave within available limit")
            }
        }
        else {
            print("Something went wrong: leave code not found")
        }
    }
}

struct DaysView: View {
    var title: String
    @Binding var numberOfValue: Double
    var isEditable: Bool = false
    var foregroundColour = Color.green
    var fontSize: CGFloat = 13
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            titleCard(title: title, frameHeight: 30, fontSize: fontSize)
            
            if isEditable {
                TextField("Enter Amount", value: $numberOfValue, format: .number)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(foregroundColour)
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            else {
                Text(formatNumber(numberOfValue))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(foregroundColour)
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(8)
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 8)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value == 0.5 {
            return "0.5"
        }
        else {
            return "\(Int(value))"
        }
    }
}

struct halfdayView: View {
    @Binding var isHalfDaySelected: Bool
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            titleCard(title: "Half day", frameHeight: 30, fontSize: 13)
            ZStack {
                Button(action: {
                    isHalfDaySelected.toggle()
                }) {
                    Image(isHalfDaySelected ? "check-box" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.vertical, 8)
            .background(Color.white)
            .shadow(radius: 1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 8)
        .shadow(radius: 3)
    }
}

struct titleView: View {
    let title: String
    var foregroundColor: Color = .black
    var fontSize: CGFloat = 13
    var fontWeight: Font.Weight = .light
    var body: some View {
        Text(title)
            .foregroundColor(foregroundColor)
            .font(.system(size: fontSize))
            .fontWeight(fontWeight)
            .padding(.leading, 5)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CustomTextView: View {
    @Binding var text: String
    var placeholder: String = "Enter text..."
    var cornerRadius: CGFloat = 8
    var fontSize: CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.system(size: fontSize))
                .padding(.horizontal, 4)
                .padding(.top, 6)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .cornerRadius(cornerRadius)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .frame(minHeight: 100)
            
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: fontSize))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
                    .allowsHitTesting(false)
            }
        }
    }
}

struct LeaveAvailabilityList: View {
    @ObservedObject var LeaveModel: LeaveRequestViewModel
    @Binding var selectedLeaveCode: String?
    
    var body: some View {
        VStack {
            titleView(title: "Leave Availability Status", foregroundColor: .green, fontWeight: .bold)
            
            HStack {
                titleView(title: "Type", foregroundColor: .black, fontWeight: .bold)
                titleView(title: "Eligibility", foregroundColor: .black, fontWeight: .bold)
                titleView(title: "Taken", foregroundColor: .black, fontWeight: .bold)
                titleView(title: "Available", foregroundColor: .black, fontWeight: .bold)
            }
            
            if LeaveModel.LeaveRequestData.count == 0 {
                Text("Loading...")
                    .foregroundColor(.gray)
            }
            else {
                ScrollView {
                    LazyVStack {
                        ForEach(LeaveModel.LeaveRequestData) { leaveRequest in
                            HStack {
                                titleView(title: leaveRequest.Leave_SName, foregroundColor: .black, fontWeight: .regular)
                                
                                titleView(title: String(format: "%.1f", Double(leaveRequest.LeaveValue)), foregroundColor: .black, fontWeight: .regular)
                                
                                titleView(title: String(format: "%.1f", leaveRequest.LeaveTaken), foregroundColor: .black, fontWeight: .regular)
                                
                                titleView(title: String(format: "%.1f", leaveRequest.LeaveAvailability), foregroundColor: .black, fontWeight: .regular)
                            }
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .onTapGesture {
                                selectedLeaveCode = leaveRequest.LeaveCode
                                print("Tapped LeaveCode: \(leaveRequest.LeaveCode)")
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

struct CustomCard: View {
    let title: String
    let placeholderString: String
    var selectedValue: String? = nil
    var fontWeight: Font.Weight = .light
    var titleFontWeight: Font.Weight = .light
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView(title: title, fontWeight: titleFontWeight)
            Button(action: action) {
                Text(selectedValue ?? placeholderString)
                    .foregroundColor(selectedValue == nil ? .gray : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .font(.system(size: 14))
                    .fontWeight(fontWeight)
                    .background(
                        RoundedRectangle(cornerRadius: 8).fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 5)
        }
        .padding(5)
    }
}

struct DateCard: View {
    let title: String
    var fontWeight: Font.Weight = .light
    let placeholder: String
    @Binding var selectedDate: Date?
    @Binding var selectedTime: String?
    var pickerMode: PickerMode = .date
    var onTimeSelected: ((Date) -> Void)? = nil  // ✅ NEW callback

    @State private var showDatePicker = false
    @State private var tempDate = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView(title: title, fontWeight: fontWeight)
            
            Button(action: {
                tempDate = selectedDate ?? Date()
                showDatePicker.toggle()
            }) {
                HStack {
                    Text(selectedDate == nil ? placeholder : formatDate(selectedDate!))
                        .foregroundColor(selectedDate == nil ? .gray : .gray)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8).fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 5)
        }
        .padding(5)
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker(
                    title,
                    selection: $tempDate,
                    displayedComponents: displayedComponents()
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                
                Button("Done") {
                    selectedDate = tempDate
                    if pickerMode == .time {
                        selectedTime = formatDate(tempDate)
                        onTimeSelected?(tempDate)  // ✅ Trigger callback
                    }
                    showDatePicker = false
                }
                .padding()
            }
            .padding()
        }
    }
    
    private func displayedComponents() -> DatePicker.Components {
        switch pickerMode {
        case .date:
            return .date
        case .time:
            return .hourAndMinute
        case .dateAndTime:
            return [.date, .hourAndMinute]
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        switch pickerMode {
        case .date:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        case .time:
            formatter.dateStyle = .none
            formatter.timeStyle = .short
        case .dateAndTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        }
        return formatter.string(from: date)
    }
}

enum PickerMode {
    case date
    case time
    case dateAndTime
}

#Preview {
    LeaveRequestView()
}



