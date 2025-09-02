//
//  PermissionRequestView.swift
//  GoDairy
//
//  Created by San eforce on 02/09/25.
//

import SwiftUI

struct PermissionRequestView: View {
    
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
    @State private var showToast = false
    @StateObject var permissionModel = PermissionRequestViewModel()
    
    let Hours = ["1", "2"]
    
    enum PermissionSelectionType {
        case permissionHours
        case permissionShiftTime
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    PermissionRequestCard(title: "PERMISSION REQUEST",
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
                                          onPermissionHoursTap: {
                                            activeSelection = .permissionHours
                                          },
                                          onPermissionShiftTimeTap: {
                                            activeSelection = .permissionShiftTime
                                          })
                                          
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary) {
                    Task {
                        if PermissionDate == nil {
                            showToast = true
                            saveSuccessMessage = "Select Date"
                        }
                        else if selectedPermissionHours == nil {
                            showToast = true
                            saveSuccessMessage = "Select Hours"
                        }
                        else {
                            print("Submitting with date: \(String(describing: PermissionDate))")
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
                            SelectionView (
                                isPresented: Binding(
                                    get: { activeSelection == .permissionHours },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: Hours,
                                title: "Select Hours"
                            ) { selected in
                                selectedPermissionHours = selected
                            }
                        case .permissionShiftTime:
                            SelectionView (
                                isPresented: Binding(
                                    get: { activeSelection == .permissionShiftTime },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: permissionModel.permissionTypes,
                                title: "Shift Timing"
                            ) { selected in
                                selectedShiftTime = selected
                            }
                        }
                    }
                }
            )
            .task {
                await permissionModel.fetchPermissionShiftTimeData()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .alert(saveSuccessMessage, isPresented: $showToast) {  // 🔥 Alert here
                Button("OK", role: .cancel) {}
        }
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
    @State private var textValue = ""
    @State private var fromDate: Date? = nil
    @State private var toDate: Date? = nil
    
    var onPermissionHoursTap: () -> Void
    var onPermissionShiftTimeTap: () -> Void
    
    @State private var availablePermission: Double = 0.0
    @State private var takenHours: Double = 0.0
    @State private var currentTaken: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            DateCard(title: "Date of Permission", placeholder: "Select from Date", selectedDate: $PermissionDate,
                selectedTime: $selectedFromTime)
            
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
                DateCard(title: "From Time",
                         placeholder: "From Time",
                         selectedDate: $fromDate,
                         selectedTime:  $selectedFromTime,
                         pickerMode: .time)
                DateCard(title: "To Time",
                         placeholder: "To Time",
                         selectedDate: $toDate,
                         selectedTime:  $selectedToTime,
                         pickerMode: .time)
            }
            
            titleView(title: "Note:- Kindly use 24 hour time format", fontSize: 11, fontWeight: .light)
                .padding(.horizontal, 8)
            
            HStack {
                DaysView(title: "Available", numberOfValue: $availablePermission, isEditable: false, foregroundColour: Color.red, fontSize: 12)
                DaysView(title: "Taken Hrs", numberOfValue: $takenHours, isEditable: false, foregroundColour: Color.red, fontSize: 12)
                DaysView(title: "Curr.Taken", numberOfValue: $takenHours, isEditable: false, foregroundColour: Color.red, fontSize: 12)
            }
            .padding(.vertical, 10)
            .padding(.top, 5)
            
            titleView(title: "Reason")
            CustomTextView(text: $textValue, placeholder: "Reason")
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
