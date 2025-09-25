//
//  Check-In View.swift
//  GoDairy
//
//  Created by San eforce on 22/09/25.
//

import SwiftUI
import MapKit
import Contacts

struct CheckInFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var permissionManager = PermissionManager()
    @State private var currentStep = 0
    @State private var currentCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        VStack(spacing: 0) {
            
            //Indicator Bar
            StepIndicator(currentStep: $currentStep)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
            
            // 🔹 Step Content
            VStack {
                if currentStep == 0 {
                    if let location = permissionManager.currentLocation {
                        LocationStep(
                            onNext: {
                                withAnimation {
                                    currentStep = 1
                                }
                            },
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            coordinate: $currentCoordinate
                        )
                    }
                    else {
                        ProgressView("Fetching location...")
                            .frame(maxHeight: .infinity)
                    }
                }
                else if currentStep == 1 {
                    ShiftStep {
                        withAnimation {
                            currentStep = 2
                        }
                    }
                }
                else if currentStep == 2 {
                    SelfieStep {
                        print("✅ Final submit")
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            permissionManager.requestLocation()
        }
        .onChange(of: permissionManager.currentLocation) { newLocation in
            if let location = newLocation {
                currentCoordinate = location.coordinate
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: handleDismiss) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 15, height: 25)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Check IN")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.black)
            }
        }
        .alert("Location Permission Required",
               isPresented: $permissionManager.showPermissionAlert) {
            Button("Settings") {
                if let appSettings = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("To continue, please allow location access in Settings.")
        }
    }
    
    private func handleDismiss() {
        dismiss()
    }
}


struct StepIndicator: View {
    @Binding var currentStep: Int
    let steps = ["Location", "Shift", "Selfie"]

    private let circleSize: CGFloat = 25
    private let lineHeight: CGFloat = 2

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(steps.indices, id: \.self) { i in
                    VStack(spacing: 20) {
                        ZStack {
                            if i < currentStep {
                                // Completed step
                                Image("check")
                                    .resizable()
                                    .foregroundColor(.black)
                            }
                            else if i == currentStep {
                                // Current step
                                Image("Rounded_Circle")
                                    .resizable()
                                    .foregroundColor(.black)
                            }
                            else {
                                // Upcoming step
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: circleSize, height: circleSize)

                        Text(steps[i])
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(i <= currentStep ? .black : .gray)
                    }

                    // Connector line
                    if i < steps.count - 1 {
                        GeometryReader { geo in
                            let totalWidth = geo.size.width
                            let progress = connectorProgress(for: i)
                            let filledWidth = totalWidth * progress

                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(height: lineHeight)

                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: filledWidth, height: lineHeight)
                                    .animation(.easeInOut, value: currentStep)
                            }
                        }
                        .frame(height: lineHeight)
                        .padding(.top, -18)
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
    }

    /// Connector progress: 0 empty, 0.5 half, 1 full
    private func connectorProgress(for index: Int) -> CGFloat {
        if currentStep > index {
            return 1.0
        }
        else if currentStep == index {
            return 0.5
        }
        else {
            return 0.0
        }
    }
}

// Array safe subscript
extension Array {
    subscript(safe index: Int, default defaultValue: Element) -> Element {
        indices.contains(index) ? self[index] : defaultValue
    }
}

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct EquatableCoordinate: Equatable {
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct LocationStep: View {
    var onNext: () -> Void
    var latitude: Double
    var longitude: Double
    @Binding var coordinate: CLLocationCoordinate2D
    
    @State private var shortAddress: String = ""
    @State private var address: String = ""
    @State private var equatableCoordinate = EquatableCoordinate(coordinate: .init())

    private var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var body: some View {
        VStack(alignment: .leading) {
            MapViewWithRadius(
                coordinate: location,
                radius: 100
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )

            Text(shortAddress)
                .font(.headline)
                .padding(.top, 8)

            Text(address)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 5)

            Button("Check-In") {
                onNext()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            equatableCoordinate = EquatableCoordinate(coordinate: coordinate)
            fetchAddress(for: coordinate)
        }
        .onChange(of: equatableCoordinate) { newValue in
            fetchAddress(for: newValue.coordinate)
        }
        .onChange(of: coordinate) { newValue in
            equatableCoordinate = EquatableCoordinate(coordinate: newValue)
        }
    }
    
    private func fetchAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            if let placemark = placemarks?.first {
                let shortParts = [
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country
                ].compactMap { $0 }
                
                self.shortAddress = shortParts.joined(separator: ", ")
                
                if let postalAddress = placemark.postalAddress {
                    let formatter = CNPostalAddressFormatter()
                    var fullAddress = formatter.string(from: postalAddress)
                    fullAddress = fullAddress.replacingOccurrences(of: "\n", with: ", ")
                    self.address = fullAddress
                }
            }
            else {
                self.address = "Address not found"
            }
        }
    }
}

// 🔹 Step 2: Shift
struct ShiftStep: View {
    var onNext: () -> Void
    @StateObject var LeaveModel = LeaveRequestViewModel()
    @State private var selectedShiftId: String = ""
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(LeaveModel.LeaveShiftTimeData, id: \.id) { item in
                        let isSelected = selectedShiftId == item.id
                        
                        ShiftGridItem(
                            name: item.name,
                            Shift_StartTime: item.Sft_STime,
                            Shift_EndTime: item.sft_ETime,
                            isSelected: isSelected
                        )
                        .onTapGesture {
                            selectedShiftId = item.id
                        }
                    }
                }
                .padding()
            }
            
            if !selectedShiftId.isEmpty {
                confirmButton
            }
        }
        .onAppear {
            Task {
                await LeaveModel.fetchShiftTimeData()
            }
        }
    }
    
    private var confirmButton: some View {
        Button(action: {
            onNext()
        }) {
            Text("CONFIRM SHIFT")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .transition(.opacity)
        .animation(.easeInOut, value: selectedShiftId)
    }
}

struct ShiftGridItem: View {
    let name: String
    let Shift_StartTime: String
    let Shift_EndTime: String
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.system(size: 17))
                .fontWeight(.regular)
                .foregroundColor(Color.black)
            
            Text("\(Shift_StartTime) - \(Shift_EndTime)")
                .font(.system(size: 17))
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(isSelected ? Color.blue.opacity(0.2) : Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.4), lineWidth: 1.5)
        )
    }
}


struct SelfieStep: View {
    var onNext: () -> Void
    @StateObject private var cameraVM = CameraViewModel()
    @State private var sliderValue: Double = 0.5
    @State private var capturedImage: UIImage? = nil
    @State private var isCaptured: Bool = false   // ✅ Track state
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(session: cameraVM.session)
                .cornerRadius(12)
                .clipped()
                .padding(.bottom, 80)
            
            VStack {
                // Top controls (Flash + Switch Camera) → Only show if not captured
                if !isCaptured {
                    HStack {
                        HStack(spacing: 0) {
                            // Flash button
                            Button(action: {
                                cameraVM.toggleFlash()
                            }) {
                                Image("bolt")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            
                            // Switch camera button
                            Button(action: {
                                cameraVM.switchCamera()
                            }) {
                                Image("refresh")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .background(Color.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.leading, 20)
                }
                
                Spacer()
                
                if !isCaptured {
                    // Slider (brightness/zoom) → Only show before capture
                    Slider(value: $sliderValue)
                        .padding(.horizontal, 40)
                        .onChange(of: sliderValue) { newValue in
                            cameraVM.setBrightness(newValue)
                        }
                    
                    // Shutter Button
                    Button(action: {
                        cameraVM.capturePhoto { image in
                            if let image = image {
                                print("The CapturedImage is \(image)")
                                capturedImage = image
                                isCaptured = true   // ✅ Switch to preview mode
                            }
                        }
                    }) {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                            .background(Circle().fill(Color.white))
                            .frame(width: 70, height: 70)
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 100)
                } else {
                    // ✅ After capture → Show Retry + Finish
                    HStack(spacing: 20) {
                        Button(action: {
                            // Retry → reset to camera mode
                            capturedImage = nil
                            isCaptured = false
                        }) {
                            Text("RETRY")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Finish → move to next step
                            onNext()
                        }) {
                            Text("FINISH")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
            
            // Full preview if captured
            if let image = capturedImage, isCaptured {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


//struct SelfieStep: View {
//    var onNext: () -> Void
//    @StateObject private var cameraVM = CameraViewModel()
//    @State private var sliderValue: Double = 0.5
//    @State private var capturedImage: UIImage? = nil
//    
//    var body: some View {
//        ZStack {
//            // Camera Preview
//            CameraPreview(session: cameraVM.session)
//                .cornerRadius(12)
//                .clipped()
//                //.ignoresSafeArea()
//            
//            VStack {
//                // Top controls (Flash + Switch Camera)
//                HStack {
//                    HStack (spacing: 0) {
//                        // Flash button
//                        Button(action: {
//                            cameraVM.toggleFlash()
//                        }) {
//                            Image("bolt")
//                                .foregroundColor(.white)
//                                .padding()
//                        }
//                        
//                        // Switch camera button
//                        Button(action: {
//                            cameraVM.switchCamera()
//                        }) {
//                            Image("refresh")
//                                .foregroundColor(.white)
//                                .padding()
//                        }
//                    }
//                    .background(Color.gray.opacity(0.5))
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                    .overlay( // White border
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.white, lineWidth: 0.5)
//                    )
//                    
//                    Spacer()
//                }
//                .padding(.top, 20)
//                .padding(.leading, 20)
//                
//                Spacer()
//                
//                // Slider (zoom / custom use)
//                Slider(value: $sliderValue)
//                    .padding(.horizontal, 40)
//                
//                // Shutter Button
//                Button(action: {
//                    cameraVM.capturePhoto { image in
//                        if let image = image {
//                            capturedImage = image
//                        }
//                    }
//                }) {
//                    Circle()
//                        .strokeBorder(Color.white, lineWidth: 4)
//                        .background(Circle().fill(Color.white))
//                        .frame(width: 70, height: 70)
//                        .shadow(radius: 4)
//                }
//                .padding(.bottom, 20)
//            }
//            
//            // Small thumbnail preview (bottom-right)
//            if let image = capturedImage {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 60, height: 60)
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.white, lineWidth: 1)
//                            )
//                            .padding(.bottom, 30)
//                            .padding(.trailing, 20)
//                    }
//                }
//            }
//        }
//    }
//}

#Preview {
    NavigationView {
        CheckInFlowView()
    }
}
