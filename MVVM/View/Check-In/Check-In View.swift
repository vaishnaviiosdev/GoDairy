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
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 🔹 Top Step Indicator Bar
            StepIndicator(currentStep: $currentStep)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
            
            //Divider()
            
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
                            longitude: location.coordinate.longitude
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
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

struct LocationStep: View {
    var onNext: () -> Void
    var latitude: Double
    var longitude: Double
    @State private var shortAddress: String = ""
    @State private var address: String = ""

    private var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var body: some View {
        VStack(alignment: .leading) {
            MapViewWithRadius(
                coordinate: location,
                radius: 100 // Radius in meters
            )
            //.frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )

            // Coordinates
            Text(shortAddress)
                .font(.headline)
                .padding(.top, 8)

            Text(address)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 5)

            // Check-In Button
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
            fetchAddress(for: location)
        }
    }
    
    private func fetchAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            if let placemark = placemarks?.first {
                
                // Short address (without road/street)
                let shortParts = [
                    placemark.subThoroughfare, //(e.g. "B1")
                    placemark.locality, //(e.g. "Mumbai")
                    placemark.administrativeArea,//(e.g. "Maharashtra")
                    placemark.country  //(e.g. "India")
                ].compactMap { $0 }
                
                self.shortAddress = shortParts.joined(separator: ", ")
                print("Short Address: \(shortAddress)")
                
                // Full address
                if let postalAddress = placemark.postalAddress {
                    let formatter = CNPostalAddressFormatter()
                    var fullAddress = formatter.string(from: postalAddress)
                    fullAddress = fullAddress.replacingOccurrences(of: "\n", with: ", ")
                    self.address = fullAddress
                }
                print("Full Address: \(self.address)")
                
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
    var body: some View {
        VStack {
            Text("🕒 Select your shift")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Button("Next") { onNext() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
        }
    }
}

// 🔹 Step 3: Selfie
struct SelfieStep: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("🤳 Take a Selfie")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Button("Submit") { onNext() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
        }
    }
}

#Preview {
    NavigationView {
        CheckInFlowView()
    }
}
