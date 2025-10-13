//
//  MapKit.swift
//  GoDairy
//
//  Created by San eforce on 24/09/25.
//

import SwiftUI
import MapKit

//struct MapViewWithRadius: UIViewRepresentable {
//    let coordinate: CLLocationCoordinate2D
//    let radius: CLLocationDistance // in meters
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//
//        // Set initial region
//        let region = MKCoordinateRegion(
//            center: coordinate,
//            latitudinalMeters: radius * 5,
//            longitudinalMeters: radius * 5
//        )
//        mapView.setRegion(region, animated: false)
//
//        // Add initial annotation
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        mapView.addAnnotation(annotation)
//
//        // Add initial radius circle
//        let circle = MKCircle(center: coordinate, radius: radius)
//        mapView.addOverlay(circle)
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        print("🗺️ updateUIView called with coordinate: \(coordinate)")
//
//        // Remove old annotations and overlays
//        uiView.removeAnnotations(uiView.annotations)
//        uiView.removeOverlays(uiView.overlays)
//
//        // Set updated region
//        let region = MKCoordinateRegion(
//            center: coordinate,
//            latitudinalMeters: radius * 5,
//            longitudinalMeters: radius * 5
//        )
//        uiView.setRegion(region, animated: true)
//
//        // Add updated annotation
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        uiView.addAnnotation(annotation)
//
//        // Add updated circle
//        let circle = MKCircle(center: coordinate, radius: radius)
//        uiView.addOverlay(circle)
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            if let circleOverlay = overlay as? MKCircle {
//                let renderer = MKCircleRenderer(circle: circleOverlay)
//                renderer.strokeColor = UIColor.systemBlue
//                renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.2)
//                renderer.lineWidth = 2
//                return renderer
//            }
//            return MKOverlayRenderer(overlay: overlay)
//        }
//    }
//}

struct MapViewWithRadius: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance // in meters
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Set initial region
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: radius * 5,
            longitudinalMeters: radius * 5
        )
        mapView.setRegion(region, animated: false)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Create circle but do NOT add yet
        let circle = MKCircle(center: coordinate, radius: radius)
        context.coordinator.circleOverlay = circle
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update annotation
        uiView.removeAnnotations(uiView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
        
        // The circle overlay visibility is handled by coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var circleOverlay: MKCircle?
        
        // Render circle overlay
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circleOverlay)
                renderer.strokeColor = UIColor.systemBlue
                renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.2)
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // Show circle only when zoomed in
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            guard let circle = circleOverlay else { return }
            
            let span = mapView.region.span
            let zoomThreshold: CLLocationDegrees = 0.05 // adjust as needed
            
            // Check if circle overlay is already on the map
            let circleExists = mapView.overlays.contains { $0 === circle } // ✅ use identity check
            
            if span.latitudeDelta < zoomThreshold && !circleExists {
                mapView.addOverlay(circle) // show circle
            }
            else if span.latitudeDelta >= zoomThreshold && circleExists {
                mapView.removeOverlay(circle) // hide circle
            }
        }
    }
}

