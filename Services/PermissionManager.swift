//
//  PermissionManager.swift
//  GoDairy
//
//  Created by San eforce on 20/08/25.
//

import AVFoundation
import Photos
import CoreLocation

class PermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {//qad-801090
    @Published var cameraGranted = false
    @Published var microphoneGranted = false
    @Published var locationGranted = false
    @Published var photoLibraryGranted = false
    @Published var currentLocation: CLLocation? = nil
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Step 1: Camera
    func requestCameraPermission(completion: (() -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraGranted = granted
                completion?()
            }
        }
    }
    
    // MARK: - Step 2: Photo Library
    func requestPhotoLibraryPermission(completion: (() -> Void)? = nil) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.photoLibraryGranted = (status == .authorized || status == .limited)
                    completion?()
                }
            }
        }
        else {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    self.photoLibraryGranted = (status == .authorized)
                    completion?()
                }
            }
        }
    }
    
    func requestLocationPermission() {
        let status = CLLocationManager().authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // ✅ start updates
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.locationGranted = false
            }
        @unknown default:
            break
        }
    }
        
    // ✅ Updates whenever location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
            self.locationGranted = true
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation() // ✅ resume updates
        } else {
            DispatchQueue.main.async {
                self.locationGranted = false
                self.currentLocation = nil
            }
        }
    }
    
    // MARK: - Public flow (sequential)
    func requestAllPermissionsSequentially() {
        requestCameraPermission {
            self.requestPhotoLibraryPermission {
                self.requestLocationPermission()
            }
        }
    }
}


///////


