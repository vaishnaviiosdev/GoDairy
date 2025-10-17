//
//  GateInView.swift
//  GoDairy
//
//  Created by San eforce on 16/10/25.
//

import SwiftUI
import AVFoundation
import CoreLocation

enum GateType {
    case gateIn
    case gateOut
}

struct GateInOutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var camera = CameraService.shared
    //@State private var qrCode: String? = nil
    @StateObject private var permissionManager = PermissionManager()
    @StateObject private var gateViewModel = GateIn_OutViewModel()
    @State private var showLocationAlert = false
    @State private var hasScanned = false
    @State private var isLoading = false
    var gateType: GateType
    var titleName: String {
        gateType == .gateIn ? "GATE IN" : "GATE OUT"
    }
    
    
    var body: some View {
        ZStack {
            // Background
            Color.backgroundColour.ignoresSafeArea(.all)
            
            // Camera preview or simulator fallback
            #if targetEnvironment(simulator)
            Color.black
                .overlay(
                    Text("Camera Preview Not Available in Simulator")
                        .foregroundColor(.white)
                        .padding()
                )
            #else
            CameraView(session: camera.session)
            #endif
            
            // Overlay UI
            VStack {
                // Header
                ZStack {
                    Text(titleName)
                        .font(.system(size: 35, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            
            // Loader overlay
            if isLoading {
                ZStack {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                    
                    ProgressView("")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .scaleEffect(2.0)
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .onAppear {
            #if !targetEnvironment(simulator)
            camera.startSession()
            #endif
            
            permissionManager.requestLocationPermission()
        }
        .onDisappear {
            #if !targetEnvironment(simulator)
            camera.stopSession()
            #endif
        }
        
        .alert("Location Permission Required", isPresented: $showLocationAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable 'While Using the App' location access to use this feature.")
        }
        
        // Instead, check only when you actually need location in QR scan:
        .onReceive(camera.$scannedCode) { code in
            guard !hasScanned, let code = code else { return }
            hasScanned = true
            
            if let data = parseQRCode(code) {
                print("Parsed QR Data: \(data)")
                
                if let currentLoc = permissionManager.currentLocation {
                    let latLng = "\(currentLoc.coordinate.latitude),\(currentLoc.coordinate.longitude)"
                    
                    Task {
                        await MainActor.run { isLoading = true }
                        
                        // ✅ Unified API call
                        if titleName.uppercased().contains("IN") {
                            await gateViewModel.postGateData(
                                type: "GateIn",
                                hdloc: data["HQLoc"] ?? "",
                                hqLocId: data["HQLocID"] ?? "",
                                location: data["Location"] ?? "",
                                majourType: data["MajourType"] ?? "",
                                latLng: latLng,
                                mode: data["mode"] ?? ""
                            )
                        }
                        else if titleName.uppercased().contains("OUT") {
                            await gateViewModel.postGateData(
                                type: "GateOut",
                                hdloc: data["HQLoc"] ?? "",
                                hqLocId: data["HQLocID"] ?? "",
                                location: data["Location"] ?? "",
                                majourType: data["MajourType"] ?? "",
                                latLng: latLng,
                                mode: data["mode"] ?? ""
                            )
                        }
                        else {
                            print("⚠️ Unknown title: \(titleName). No API called.")
                        }
                        
                        await MainActor.run { isLoading = false }
                    }
                }
                else {
                    if CLLocationManager().authorizationStatus == .denied || CLLocationManager().authorizationStatus == .restricted {
                        showLocationAlert = true
                    }
                    else {
                        permissionManager.requestLocation()
                    }
                    hasScanned = false
                }
            }
            else {
                print("❌ Invalid QR Code format")
                hasScanned = false
            }
        }


        .alert(gateViewModel.saveGateSuccessMsg, isPresented: $gateViewModel.showGateSaveAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
}

func parseQRCode(_ code: String) -> [String: String]? {
    let components = code.split(separator: "|").map { String($0) }
    
    guard components.count >= 5 else { return nil }
    
    let hdloc = components[0]
    let hqLocId = components[1]
    let location = components[2]
    let mode = components[3]
    let majourType = components[4]
    
    // Optional: convert location to lat/lng if needed
    let latLng = ""
    
    return [
        "HQLoc": hdloc,
        "HQLocID": hqLocId,
        "Location": location,
        "MajourType": majourType,
        "latLng": latLng,
        "mode": mode
    ]
}

struct CameraView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    GateInOutView(gateType: .gateIn)
}
