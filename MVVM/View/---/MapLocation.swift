//
//  MapLocation.swift
//  GoDairy
//
//  Created by San eforce on 27/11/24.
//

import SwiftUI
import MapKit


struct city: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapLocation: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.0728, longitude: 80.2617), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var address: String = "Loading address..."
    
    let annotations = [
        city(name: "chennai", coordinate: CLLocationCoordinate2D(latitude: 13.0728, longitude: 80.2617))
        
    ]
    
    enum CheckInStep {
        case location, shift, selfie
    }
    @State private var currentStep: CheckInStep = .location
    
    @State private var showDayPlan = false
    @State private var navigateToNextPages = false
    
    var body: some View {
        NavigationStack{
            Text("Check IN")
                .foregroundColor(.black)
            Spacer()
                .frame(maxHeight: .infinity)
            
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
            
            
            Map(coordinateRegion: $region,showsUserLocation: true, userTrackingMode: .constant(.follow),annotationItems: annotations){
                MapPin(coordinate: $0.coordinate)
                
            }
            .frame(width: 400, height: 400)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(20)
            
            Text(address)
                .font(.body)
                .foregroundColor(.black)
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(maxHeight: .infinity)
            //if let _ = selectedItem {
            Button(action: {
                self.navigateToNextPages = true
                // print("Shift confirmed: \(selectedItem!.count)")
                
            }) {
                Text("Confirm Shift")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("App_Primary"))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
            
            Spacer()
                .navigationTitle("")
                .background(
                    NavigationLink(destination: ShiftView(), isActive: $navigateToNextPages){
                        EmptyView()
                    }
                )
        }
                .onAppear {
                                // Perform reverse geocoding to fetch the address when the view appears
                                fetchAddress(for: annotations.first?.coordinate)
                            }
            
        }
        //}
//}
    
    private func fetchAddress(for coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error fetching address: \(error.localizedDescription)")
                self.address = "Unable to fetch address"
                return
            }
            
            if let placemark = placemarks?.first {
                self.address = placemark.name ?? "Unknown Location"
                if let subThoroughfare = placemark.subThoroughfare, let thoroughfare = placemark.thoroughfare {
                    self.address = "\(subThoroughfare) \(thoroughfare)"
                }
                if let locality = placemark.locality {
                    self.address += ", \(locality)"
                }
                if let administrativeArea = placemark.administrativeArea {
                    self.address += ", \(administrativeArea)"
                }
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

#Preview {
    MapLocation()
}
