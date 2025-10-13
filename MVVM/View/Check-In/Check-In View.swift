////
////  Check-In View.swift
////  GoDairy
////
////  Created by San eforce on 22/09/25.
//
import SwiftUI
import MapKit
import Contacts

struct CheckInFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var permissionManager = PermissionManager()
    @StateObject private var checkInModel = Checkinviewmodel()
    @State private var currentStep = 0
    @State private var currentCoordinate = CLLocationCoordinate2D()
    
    @State private var selectedShiftName = ""
    @State private var selectedShiftStartTime = ""
    @State private var selectedShiftEndTime = ""
    @State private var selectedShiftId = ""
    @State private var selectedCutOffDate = ""
    @State private var isCheckingIn = false
    @State private var isCheckingOut = false

    let Cnt: Int?
    let wrkType: String
    let checkOnDuty: Int?
    var titleName: String
    var startFromStep: Int = 0
    var isFirstTimeCheckIn: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                StepIndicator(currentStep: $currentStep)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 50)
                
                VStack {
                    if currentStep == 0 {
                        if let location = permissionManager.currentLocation {
//                            LocationStep(
//                                onNext: {
//                                    withAnimation {
//                                        currentStep = 1
//                                    }
//                                },
//                                latitude: location.coordinate.latitude,
//                                longitude: location.coordinate.longitude,
//                                coordinate: $currentCoordinate
//                            )
                            LocationStep(
                                onNext: {
                                    withAnimation {
                                        currentStep = isFirstTimeCheckIn ? 1 : 2
                                    }
                                },
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude,
                                coordinate: $currentCoordinate
                            )//Isfirsttimecheckin == false -> SelfieStep
                            //Isfirsttimecheckin == true -> shiftstep
                        }
                        else {
                            ProgressView("Fetching location...")
                                .frame(maxHeight: .infinity)
                        }
                    }
                    else if currentStep == 1 {
                        ShiftStep(
                            onNext: {
                                withAnimation {
                                    currentStep = 2
                                }
                            },
                            latitude: currentCoordinate.latitude,
                            longitude: currentCoordinate.longitude,
                            selectedShiftName: $selectedShiftName,
                            selectedShiftStartTime: $selectedShiftStartTime,
                            selectedShiftEndTime: $selectedShiftEndTime,
                            selectedShiftId: $selectedShiftId,
                            selectedCutOffDate: $selectedCutOffDate
                        )
                    }
                    else if currentStep == 2 {
                        SelfieStep(
                            onNext: { lat, long, sName, sStart, sEnd, sId, sCutOff, cnt, wType, onDuty, selfieImage, imageData, fileName, isCheckout in
                                Task {
                                    await handleSelfieStep(
                                        lat: lat,
                                        long: long,
                                        sName: sName,
                                        sStart: sStart,
                                        sEnd: sEnd,
                                        sId: sId,
                                        sCutOff: sCutOff,
                                        cnt: cnt,
                                        wType: wType,
                                        onDuty: onDuty,
                                        selfieImage: selfieImage,
                                        imageData: imageData,
                                        fileName: fileName,
                                        isCheckout: isCheckout
                                    )
                                }
                            },
                            latitude: currentCoordinate.latitude,
                            longitude: currentCoordinate.longitude,
                            shiftName: selectedShiftName,
                            shiftStartTime: selectedShiftStartTime,
                            shiftEndTime: selectedShiftEndTime,
                            shiftId: selectedShiftId,
                            shiftCutOff: selectedCutOffDate,
                            cnt: Cnt ?? 0,
                            wType: wrkType,
                            checkOnDuty: checkOnDuty ?? 0,
                            titleName: titleName
                        )
                    }
                }
                .frame(maxHeight: .infinity)
            }
            
            // Loader Overlay
            if isCheckingIn {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text("Checking in...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(20)
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            permissionManager.requestLocation()
            currentStep = startFromStep
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
                    BackIcon()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(titleName)
                    .regularTextStyle(size: 17)
//                    .font(.system(size: 17, weight: .regular))
//                    .foregroundColor(.black)
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
        .alert(checkInModel.checkInSuccessMsg,
               isPresented: $checkInModel.checkInSaveAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        .alert(checkInModel.checkOutSuccessMsg,
                isPresented: $checkInModel.checkOutSaveAlert) {
            Button("OK", role: .cancel) {
                       dismiss()
            }
        }
        .onAppear {
            Task {
                await MainActor.run {
                    print("The isFirstTimeCheckIn is \(isFirstTimeCheckIn)")
                }
            }
        }
    }
    
    private func handleDismiss() {
        dismiss()
    }
    
    private func handleSelfieStep(
        lat: Double,
        long: Double,
        sName: String,
        sStart: String,
        sEnd: String,
        sId: String,
        sCutOff: String,
        cnt: Int,
        wType: String,
        onDuty: Int,
        selfieImage: UIImage,
        imageData: Data,
        fileName: String,
        isCheckout: Bool
    ) async {
        await MainActor.run {
            if isCheckout {
                isCheckingOut = true
            }
            else {
                isCheckingIn = true
            }
        }
        
        print("The IsCheckOut Value is \(isCheckout)")
        if isCheckout {
            await checkInModel.checkOutSavePost(selfieImage: selfieImage, selfieImageData: imageData, latitude: lat, longitude: long, checkOnDuty: onDuty)
        }
        else {
            await checkInModel.CheckInSavePost(
                shiftId: sId,
                shiftName: sName,
                shiftStart: sStart,
                shiftEnd: sEnd,
                shiftCutOff: sCutOff,
                latitude: lat,
                longitude: long,
                cnt: cnt,
                wType: wType,
                checkOnDuty: onDuty,
                selfieImage: selfieImage,
                selfieImageData: imageData,
                fileName: fileName
            )
        }

        await MainActor.run {
            isCheckingIn = false
            isCheckingOut = false
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
//                            .font(.system(size: 13))
//                            .fontWeight(.semibold)
//                            .foregroundColor(i <= currentStep ? .black : .gray)
                            .regularTextStyle(size: 13, foreground: (i <= currentStep ? .black : .gray), fontWeight: .semibold)
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
    var latitude: Double
    var longitude: Double
    @StateObject var LeaveModel = LeaveRequestViewModel()
    
    @Binding var selectedShiftName: String
    @Binding var selectedShiftStartTime: String
    @Binding var selectedShiftEndTime: String
    @Binding var selectedShiftId: String
    @Binding var selectedCutOffDate: String
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
                            selectedShiftName = item.name
                            selectedShiftStartTime = item.Sft_STime
                            selectedShiftEndTime = item.sft_ETime
                            selectedCutOffDate = item.ACutOff?.date ?? ""
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
                .regularTextStyle(size: 16, foreground: .white, fontWeight: .semibold)
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(.white)
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
//                .font(.system(size: 17))
//                .fontWeight(.regular)
//                .foregroundColor(Color.black)
                .regularTextStyle(size: 17)
            
            Text("\(Shift_StartTime) - \(Shift_EndTime)")
//                .font(.system(size: 17))
//                .fontWeight(.regular)
//                .foregroundColor(Color.gray)
                .regularTextStyle(size: 17, foreground: .gray)
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
    var onNext: @Sendable (
        _ latitude: Double,
        _ longitude: Double,
        _ shiftName: String,
        _ shiftStartTime: String,
        _ shiftEndTime: String,
        _ shiftId: String,
        _ shiftCutOff: String,
        _ cnt: Int,
        _ wType: String,
        _ checkOnDuty: Int,
        _ selfieImage: UIImage,
        _ imageData: Data,
        _ fileName: String,
        _ isCheckout: Bool
    ) async -> Void
    var latitude: Double
    var longitude: Double
    var shiftName: String
    var shiftStartTime: String
    var shiftEndTime: String
    var shiftId: String
    var shiftCutOff: String
    var cnt: Int
    var wType: String
    var checkOnDuty: Int
    var titleName: String
    
    @StateObject private var cameraVM = CameraViewModel()
    @State private var isCheckout: Bool = false
    @State private var sliderValue: Double = 0.5
    @State private var capturedImage: UIImage? = nil
    @State private var isCaptured: Bool = false   // ✅ Track state
    
    var body: some View {
        ZStack {
            // 👇 Camera only when not captured
            if !isCaptured {
                CameraPreview(session: cameraVM.session)
                    .cornerRadius(12)
                    .clipped()
                    .padding(.bottom, 80)
                    .padding(.horizontal, 20)
            }

            // ✅ Show captured image when available
            if let image = capturedImage, isCaptured {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .clipped()
                            .padding(.bottom, 80)
                            .padding(.horizontal, 20)

                        Button(action: {
                            isCaptured = false
                            capturedImage = nil
                        }) {
                            Text("RETRY")
//                                .font(.system(size: 20, weight: .semibold))
//                                .foregroundColor(.white)
                                .regularTextStyle(size: 20, foreground: .white, fontWeight: .semibold)
                                .frame(height: 35)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .padding([.top, .trailing], 15)
                        }
                        .padding(.trailing, 15)
                    }
                    Spacer()
                }
            }

            VStack {
                // 🔦 Flash + Switch Camera → Only when camera is visible
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
                
                if isCaptured {
                    // ✅ Finish button full-width bottom
                    Button(action: {
                        if let image = capturedImage,
                           let imageData = image.jpegData(compressionQuality: 0.8) {
                            let fileName = "MGR80_\(Int(Date().timeIntervalSince1970)).jpg"
                            Task {
                                await onNext(
                                    latitude,
                                    longitude,
                                    shiftName,
                                    shiftStartTime,
                                    shiftEndTime,
                                    shiftId,
                                    shiftCutOff,
                                    cnt,
                                    wType,
                                    checkOnDuty,
                                    image,
                                    imageData,
                                    fileName,
                                    isCheckout
                                )
                            }
                        }
                    }) {
                        Text("FINISH")
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(.white)
                            .regularTextStyle(size: 16, foreground: .white, fontWeight: .bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                else {
                    // 👇 Show shutter + slider only if not captured
                    Slider(value: $sliderValue)
                        .padding(.horizontal, 40)
                        .onChange(of: sliderValue) { newValue in
                            cameraVM.setBrightness(newValue)
                        }

                    Button(action: {
                        cameraVM.capturePhoto { image in
                            if let image = image {
                                capturedImage = image
                                isCaptured = true
                                isCheckout = titleName.lowercased() == "check out"
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
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CheckInFlowView(Cnt: nil, wrkType: "", checkOnDuty: nil, titleName: "")
    }
}





