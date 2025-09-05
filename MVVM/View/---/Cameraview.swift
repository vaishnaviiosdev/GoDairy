import SwiftUI
import AVFoundation

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var isCameraReady = false
    @Published var isFlashOn = false
    @Published var capturedImage: UIImage?
    @Published var isFrontCamera = true
    
    private var deviceInput: AVCaptureDeviceInput?
    private let photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        setupSession()
    }
    
    func setupSession() {
        session.beginConfiguration()
        
        // Default to front camera
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        // Remove any existing inputs
        session.inputs.forEach { session.removeInput($0) }
        
        deviceInput = input
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async {
                self?.isCameraReady = true
            }
        }
    }
    
    func toggleCamera() {
        let position: AVCaptureDevice.Position = isFrontCamera ? .back : .front
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        session.beginConfiguration()
        if let existingInput = deviceInput {
            session.removeInput(existingInput)
        }
        if session.canAddInput(input) {
            session.addInput(input)
            deviceInput = input
        }
        session.commitConfiguration()
        
        isFrontCamera.toggle()
    }
    
    func toggleFlash() {
        guard let device = deviceInput?.device else { return }
        
        do {
            try device.lockForConfiguration()
            if device.hasTorch {
                device.torchMode = device.torchMode == .off ? .on : .off
                isFlashOn.toggle()
            }
            device.unlockForConfiguration()
        } catch {
            print("Flash error: \(error)")
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = isFlashOn ? .on : .off
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.capturedImage = image
            }
        }
    }
}

struct CamPreview: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct CameraView: View {
    enum CheckInStep {
        case location, shift, selfie
    }
    
    @StateObject private var cameraManager = CameraManager()
    @State private var currentStep: CheckInStep = .selfie
    @State private var isRetrying = false
    @State private var navigateToNextPages = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Check IN")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                
                // Progress indicator
                HStack(spacing: 0) {
                    ForEach([CheckInStep.location, .shift, .selfie], id: \.self) { step in
                        Circle()
                            .fill(currentStep == step ? Color.black : Color.black.opacity(0.9))
                            .frame(width: 12, height: 12)
                        
                        if step != .selfie {
                            Rectangle()
                                .fill(Color.black.opacity(0.9))
                                .frame(height: 2)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                // Step labels
                HStack(spacing: 0) {
                    Text("Location")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    Text("Shift")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    Text("Selfie")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
                .font(.subheadline)
                
                // Camera view
                ZStack {
                    if cameraManager.isCameraReady {
                        CamPreview(cameraManager: cameraManager)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    VStack {
                        HStack {
                            Button(action: { cameraManager.toggleFlash() }) {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Button(action: { cameraManager.toggleCamera() }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                        
                        if isRetrying {
                            Button(action: { isRetrying = false }) {
                                Text("RETRY")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                .frame(height: 400)
                
                // Capture button
                Button(action: { cameraManager.capturePhoto() }) {
                    Circle()
                        .fill(Color.white)
                        .overlay(
                            Circle()
                                .stroke(Color.secondary, lineWidth: 3)
                        )
                        .frame(width: 70, height: 70)
                        .shadow(radius: 4)
                }
                
                // Finish button
                if currentStep == .selfie {
                    Button(action: { navigateToNextPages = true }) {
                        Text("FINISH")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("App_Primary"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: checkInDashboard(), isActive: $navigateToNextPages) {
                    EmptyView()
                }
                
                Spacer()
                    .frame(height: 30)
            }
        }
    }
//}
    
    /*   HStack(spacing: 0) {
     ForEach([CheckInStep.location, .shift, .selfie], id: \.self) { step in
     Circle()
     .fill(currentStep == step ? Color.black : (getStepIndex(step) < getStepIndex(currentStep) ? Color.black : Color.black.opacity(0.2)))
     .frame(width: 12, height: 12)
     
     if step != .selfie {
     Rectangle()
     .fill(getStepIndex(step) < getStepIndex(currentStep) ? Color.black : Color.black.opacity(0.2))
     .frame(height: 2)
     }
     }
     }
     .padding(.horizontal, 40)
     
     
     HStack(spacing: 0) {
     Text("Location")
     .frame(maxWidth: .infinity)
     Text("Shift")
     .frame(maxWidth: .infinity)
     Text("Selfie")
     .frame(maxWidth: .infinity)
     }
     .font(.subheadline)
     */
    
//    private func getStepIndex(_ step: CheckInStep) -> Int {
//        switch step {
//        case .location: return 0
//        case .shift: return 1
//        case .selfie: return 2
//        }
//    }
//}
private func getStepIndex(_ step: CheckInStep) -> Int {
    switch step {
    case .location: return 0
    case .shift: return 1
    case .selfie: return 2
    }
}
}


struct CameraPreviewLayerView: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let previewLayer = previewLayer {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}



struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}





/*import SwiftUI
import AVFoundation


class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    private var captureSession: AVCaptureSession?
    private var cameraOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    @Published var session = AVCaptureSession()
    @Published var isCameraReady = false
    @Published var isFlashOn = false
    @Published var capturedImage: UIImage?
    
    private var deviceInput: AVCaptureDeviceInput?
    private let photoOutput = AVCapturePhotoOutput()
    

    override init() {
        super.init()
        configureCamera()
    }

    private func configureCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(videoDeviceInput)

        cameraOutput = AVCapturePhotoOutput()
        if captureSession?.canAddOutput(cameraOutput!) == true {
            captureSession?.addOutput(cameraOutput!)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        
        captureSession?.startRunning()
        
        DispatchQueue.main.async {
            self.isCameraReady = true
        }
    }
    
    
    func setupSession() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        deviceInput = input
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func toggleFlash() {
        guard let device = deviceInput?.device else { return }
        
        do {
            try device.lockForConfiguration()
            if device.hasTorch {
                device.torchMode = device.torchMode == .off ? .on : .off
                isFlashOn.toggle()
            }
            device.unlockForConfiguration()
        } catch {
            print("Flash error: \(error)")
        }
    }
    
    func capturePhoto() {
        guard let photoOutput = cameraOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        
        if isFlashOn {
              settings.flashMode = .on
          } else {
              settings.flashMode = .off
          }
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }

    // AVCapturePhotoCaptureDelegate method to process captured photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let uiImage = UIImage(data: data) {
            capturedImage = uiImage
        }
    }
}


struct CameraView: View {
    enum CheckInStep {
        case location, shift, selfie
    }
    
    @State private var currentStep: CheckInStep = .selfie
    @State private var isShowingCamera = false
    @State private var isRetrying = false
    @State private var navigateToNextPages = false
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        NavigationStack{
        VStack(spacing: 20) {
            // Header with back button
            HStack {
                //                Button(action: {
                //                    // Handle back action
                //                }) {
                //                    Image(systemName: "chevron.left")
                //                        .font(.system(size: 24))
                //                        .foregroundColor(.black)
                //                }
                Spacer()
                
                Text("Check IN")
                    .font(.headline)
                    .frame(maxWidth: .infinity,alignment: .center)
                Spacer()
            }
            .padding()
            
            
            HStack(spacing: 0) {
                ForEach([CheckInStep.location, .shift, .selfie], id: \.self) { step in
                    Circle()
                        .fill(currentStep == step ? Color.black : (getStepIndex(step) < getStepIndex(currentStep) ? Color.black : Color.black.opacity(0.2)))
                        .frame(width: 12, height: 12)
                    
                    if step != .selfie {
                        Rectangle()
                            .fill(getStepIndex(step) < getStepIndex(currentStep) ? Color.black : Color.black.opacity(0.2))
                            .frame(height: 2)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            
            HStack(spacing: 0) {
                Text("Location")
                    .frame(maxWidth: .infinity)
                Text("Shift")
                    .frame(maxWidth: .infinity)
                Text("Selfie")
                    .frame(maxWidth: .infinity)
            }
            .font(.subheadline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                VStack {
                    HStack {
                        Button(action: {
                            // Toggle flash
                        }) {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(colorData.shared.Appcolor)
                                .padding(8)
                                .background(Color.black.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Button(action: {
                            // Toggle camera
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(colorData.shared.Appcolor)
                                .padding(8)
                                .background(Color.black.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    if isRetrying {
                        Button(action: {
                            isRetrying = false
                        }) {
                            Text("RETRY")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .frame(height: 400)
            
            Button(action: {
                cameraManager.capturePhoto()
            }) {
                Circle()
                    .fill(Color.white)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 4)
                    )
                    .frame(width: 70, height: 70)
                    .shadow(radius: 10)
            }
            .padding(.bottom, 0)
            
            // Bottom button
            if currentStep == .selfie {
                Button(action: {
                    navigateToNextPages = true
                                       
                }) {
                    Text("FINISH")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colorData.shared.Appcolor)
                }
                .padding(.horizontal)
            }
            NavigationLink(destination: checkInDashboard(),
                           isActive: $navigateToNextPages){
                EmptyView()
            }
            
            Spacer()
                .frame(height: 30)
        }
    }
    }
   
    private func getStepIndex(_ step: CheckInStep) -> Int {
        switch step {
        case .location: return 0
        case .shift: return 1
        case .selfie: return 2
        }
    }
    
}

struct CameraPreviewLayerView: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let previewLayer = previewLayer {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}



struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}*/












/*import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraModel = CameraViewModel()
    @State private var currentStep: Step = .selfie
    
    enum Step {
        case location, shift, selfie
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation header
            HStack {
//                Button(action: { dismiss() }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 20, weight: .medium))
//                        .foregroundColor(.blue)
//                }
                
                Spacer()
                
                Text("Check IN")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.blue)
                
                Spacer()
                
                // Invisible spacer for symmetry
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .opacity(0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 20)
            
            // Progress tracker
            VStack(spacing: 12) {
                // Progress dots and lines
                HStack(spacing: 0) {
                    ForEach([Step.location, .shift, .selfie], id: \.self) { step in
                        HStack(spacing: 0) {
                            Circle()
                                .fill(stepColor(for: step))
                                .frame(width: 8, height: 8)
                            
                            if step != .selfie {
                                Rectangle()
                                    .fill(stepLineColor(for: step))
                                    .frame(height: 1)
                            }
                        }
                    }
                }
                .frame(width: 240)
                
                // Step labels
                HStack(spacing: 0) {
                    ForEach([Step.location, .shift, .selfie], id: \.self) { step in
                        Text(step.title)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: 240)
            }
            .padding(.bottom, 20)
            
            // Rest of the view remains the same
            ZStack {
                if let image = cameraModel.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    CameraPreview(session: cameraModel.session)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                // Camera controls overlay
                VStack {
                    HStack {
                        HStack(spacing: 16) {
                            Button(action: { cameraModel.toggleFlash() }) {
                                Image(systemName: cameraModel.isFlashOn ? "bolt.fill" : "bolt.slash")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: { cameraModel.switchCamera() }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.25))
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        if cameraModel.capturedImage != nil {
                            Button(action: {
                                cameraModel.capturedImage = nil
                            }) {
                                Text("RETRY")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(16)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            // Bottom button area
            VStack {
                if cameraModel.capturedImage != nil {
                    Button(action: {
                        // Handle finish action
                    }) {
                        Text("FINISH")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    Button(action: {
                        cameraModel.capturePhoto()
                    }) {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                            .background(Circle().fill(Color.white))
                            .frame(width: 72, height: 72)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.vertical, 24)
        }
        .background(Color.white)
        .onAppear {
            cameraModel.checkPermissions()
        }
    }
    
    private func stepColor(for step: Step) -> Color {
        if currentStep == step {
            return .black
        } else {
            let currentIndex = stepIndex(for: currentStep)
            let stepIndex = stepIndex(for: step)
            return stepIndex <= currentIndex ? .black : Color.gray.opacity(0.3)
        }
    }
    
    private func stepLineColor(for step: Step) -> Color {
        let currentIndex = stepIndex(for: currentStep)
        let stepIndex = stepIndex(for: step)
        return stepIndex < currentIndex ? .black : Color.gray.opacity(0.3)
    }
    
    private func stepIndex(for step: Step) -> Int {
        switch step {
        case .location: return 0
        case .shift: return 1
        case .selfie: return 2
        }
    }
}

extension CameraView.Step {
    var title: String {
        switch self {
        case .location: return "Location"
        case .shift: return "Shift"
        case .selfie: return "Selfie"
        }
    }
}
    
  /*  private func getPreviousStep(_ step: Step) -> Step {
        switch step {
        case .location: return .location
        case .shift: return .location
        case .selfie: return .shift
        }
    }
}*/

class CameraViewModel: ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var isFlashOn = false
    @Published var capturedImage: UIImage?
    
    private var deviceInput: AVCaptureDeviceInput?
    private let photoOutput = AVCapturePhotoOutput()
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupSession()
                    } else {
                        // Handle permission denial case
                        print("Camera permission denied")
                    }
                }
            }
        case .denied, .restricted:
            // Show alert to the user about camera permissions
            print("Camera access restricted or denied")
        @unknown default:
            break
        }
    }

    
    func setupSession() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        deviceInput = input
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func toggleFlash() {
        guard let device = deviceInput?.device else { return }
        
        do {
            try device.lockForConfiguration()
            if device.hasTorch {
                device.torchMode = device.torchMode == .off ? .on : .off
                isFlashOn.toggle()
            }
            device.unlockForConfiguration()
        } catch {
            print("Flash error: \(error)")
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        
        guard let currentInput = deviceInput else { return }
        session.removeInput(currentInput)
        
        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .front ? .back : .front
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        deviceInput = newInput
        if session.canAddInput(newInput) {
            session.addInput(newInput)
        }
        
        session.commitConfiguration()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: PhotoCaptureDelegate(completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.capturedImage = image
            }
        }))
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            completion(nil)
            return
        }
        completion(image)
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environment(\.colorScheme, .light)
            //.frame(width: 300, height: 600)
            .background(Color.gray)
            .padding(.trailing,20)
    }
}
*/
