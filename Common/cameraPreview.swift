//
//  cameraPreview.swift
//  GoDairy
//
//  Created by San eforce on 25/09/25.
//

import SwiftUI
import AVFoundation

// MARK: - Camera Preview SwiftUI Wrapper
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        return PreviewView(session: session)
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}
}

// MARK: - UIKit Preview View
class PreviewView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer!

    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}


// MARK: - Camera Preview
class CameraViewModel: ObservableObject {
    let session = AVCaptureSession()
    private var currentDevice: AVCaptureDevice?
    private var currentInput: AVCaptureDeviceInput?
    private let photoOutput = AVCapturePhotoOutput()

    @Published var isFlashOn = false
    private var usingFrontCamera = true

    // Keep strong reference to the processor
    private var photoCaptureProcessor: PhotoCaptureProcessor?

    init() {
        setupSession()
    }

    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video,
                                                position: .front) {
            addInput(for: device)
        }

        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    private func addInput(for device: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
                currentInput = input
                currentDevice = device
            }
        } catch {
            print("Error adding input: \(error)")
        }
    }

    func toggleFlash() {
        guard let device = currentDevice else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if isFlashOn {
                    device.torchMode = .off
                } else {
                    try device.setTorchModeOn(level: 1.0)
                }
                isFlashOn.toggle()
                device.unlockForConfiguration()
            } catch {
                print("Flash toggle failed: \(error)")
            }
        }
    }

    func setBrightness(_ value: Double) {
        guard let device = currentDevice else { return }
        do {
            try device.lockForConfiguration()
            let minBias: Float = -2.0
            let maxBias: Float = 2.0
            let bias = minBias + Float(value) * (maxBias - minBias)

            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.setExposureTargetBias(bias) { _ in }
            }

            device.unlockForConfiguration()
        } catch {
            print("Failed to set brightness: \(error)")
        }
    }

    func switchCamera() {
        session.beginConfiguration()

        if let currentInput = currentInput {
            session.removeInput(currentInput)
        }

        let newPosition: AVCaptureDevice.Position = usingFrontCamera ? .back : .front

        if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: newPosition) {
            addInput(for: newDevice)
            usingFrontCamera.toggle()
        }

        session.commitConfiguration()
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = isFlashOn ? .on : .off

        let processor = PhotoCaptureProcessor { [weak self] image in
            completion(image)
            print("The Completion image is \(image ?? UIImage())")
            self?.photoCaptureProcessor = nil // Release processor when done
        }

        photoCaptureProcessor = processor // Keep strong reference
        photoOutput.capturePhoto(with: settings, delegate: processor)
    }
}

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    private let completionHandler: (UIImage?) -> Void

    init(completion: @escaping (UIImage?) -> Void) {
        self.completionHandler = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("Photo capture error: \(error)")
            completionHandler(nil)
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            completionHandler(nil)
            return
        }

        completionHandler(image)
    }
}

