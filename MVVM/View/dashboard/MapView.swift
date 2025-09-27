//
//  MapView.swift
//  GoDairy
//
//  Created by San eforce on 27/09/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    var latitude: Double
    var longitude: Double
    
    private var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    private var initialLocation: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    @StateObject private var permissionManager = PermissionManager()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Map fills the whole screen
            MapViewWithRadius(
                coordinate: permissionManager.currentLocation?.coordinate ?? initialLocation,
                radius: 20
            )
            
            // Custom top bar with Back + GPS button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 15, height: 25)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(10)
                }
                
                Spacer()
                
                Button(action: {
                    permissionManager.requestLocation()
                }) {
                    Image("target")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(5, corners: .allCorners)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .navigationBarBackButtonHidden(true)
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
            Text("To fetch the current location, please allow location access in Settings.")
        }
    }
}

#Preview {
    MapView(latitude: 13.0300342, longitude: 80.2414548)
}
