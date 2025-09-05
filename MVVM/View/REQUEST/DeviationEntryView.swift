//
//  DeviationEntryView.swift
//  GoDairy
//
//  Created by San eforce on 05/09/25.
//

import SwiftUI

struct DeviationEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDeviationType: String? = nil
    @State private var SelectedDeviationDate: Date? = nil
    @State private var reason: String = ""
    @State private var activeSelection: DeviationEntryType? = nil
    @State private var saveSuccessMessage: String = ""
    @State private var showToast = false
    @State private var showPermissionAlert = false
    @State private var selectedFromTime: String? = nil
    
    @StateObject var DeviationEntryModel = DeviationEntryViewModel()
    
    @StateObject private var permissionManager = PermissionManager()
    
    //@StateObject var weekOffModel = WeeklyOffViewModel()
    
    enum DeviationEntryType {
        case DeviationType
    }
    
    private func validateForm() -> String? {
        if selectedDeviationType == nil {
            return "Select Date"
        }
        else if reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter Remarks"
        }
        else if permissionManager.currentLocation == nil {
            permissionManager.requestLocationPermission()
            return "Location not available. Please enable location services."
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                ScrollView {
                    DeviationEntryCard(title: "DEVIATION ENTRY", selectedDeviationType: $selectedDeviationType, SelectedDeviationDate: $SelectedDeviationDate,
                        selectedFromTime: $selectedFromTime,
                        reason: $reason,
                        onPunchDeviationTypeTap: {
                        activeSelection = .DeviationType
                    })
                }
                CustomBtn(title: "SUBMIT", height: 40, backgroundColor: .appPrimary) {
                    Task {
                        if let errorMessage = validateForm() {
                            saveSuccessMessage = errorMessage
                            showToast = true
                        }
                        else {
                            if let location = permissionManager.currentLocation {
                                print("📍 Latitude: \(location.coordinate.latitude)")
                                print("📍 Longitude: \(location.coordinate.longitude)")
                            }
                        }
                    }
                }
                .padding()
            }
            .overlay (
                Group {
                    if let selection = activeSelection {
                        switch selection {
                        case .DeviationType:
                            SelectionView(
                                isPresented: Binding(
                                    get: { activeSelection == .DeviationType },
                                    set: { if !$0 { activeSelection = nil } }
                                ),
                                items: DeviationEntryModel.DeviationEntryName,
                                title: "Select Hours"
                            ) { selected in
                                selectedDeviationType = selected
                            }
                        }
                    }
                }
            )
            .task {
                await DeviationEntryModel.postDeviationTypeRequest()
            }
//            .alert(weekOffModel.saveWeeklyOffSuccessMsg, isPresented: $weekOffModel.showWeeklyOffSaveAlert) {
//                Button("OK", role: .cancel) {
//                    dismiss()
//                }
//            }
            .onAppear {
                permissionManager.requestLocationPermission()
            }
            .onChange(of: permissionManager.locationGranted) { granted in
                if !granted {
                    showPermissionAlert = true
                }
            }
            .alert("Location Permission Required", isPresented: $showPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable 'While Using the App' location access to use this feature.")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DeviationEntryCard: View {
    let title: String
    @Binding var selectedDeviationType: String?
    @Binding var SelectedDeviationDate: Date?
    @Binding var selectedFromTime: String?
    @Binding var reason: String
    
    //var onPunchDateTap: () -> Void
    var onPunchDeviationTypeTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            CustomCard(
                title: "Deviation",
                placeholderString: "Deviation Type",
                selectedValue: selectedDeviationType,
                action: onPunchDeviationTypeTap
            )
            
            DateCard(
                title: "Date",
                placeholder: "Select the Date",
                selectedDate: $SelectedDeviationDate,
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
    DeviationEntryView()
}



