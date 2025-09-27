//
//  Todayview.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//


import SwiftUI
import MapKit

struct Todayview: View {
    @StateObject var dashboardModel = dashboardViewModel()
    @State private var showMap = false
    @State private var mapLat: Double = 0.0
    @State private var mapLong: Double = 0.0
    //@State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var selectedCoordinate: Coordinate? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Check-in Date
                HStack {
                    if let date = dashboardModel.checkInDate.toDate() {
                        Text(date.formattedAsDDMMYYYY())
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    } else {
                        Text(dashboardModel.checkInDate)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // MARK: - Shift time & late status
                HStack {
                    Text("(\(dashboardModel.shiftTimeRange))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    Spacer()
                    Image("Late")
                    Text("Late")
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .foregroundColor(colorData.shared.app_primary2)
                }
                .padding(.horizontal, 20)
                
                // MARK: - IN / OUT Time HStack
                HStack(spacing: 10) {
                    // IN Time
                    VStack(alignment: .leading) {
                        Text("IN time")
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                        
                        HStack {
    //                        let inFullPath = getFullPath(for: dashboardModel.InTimeImageStr)
    //                        //print("IN time image full path: \(inFullPath)")
    //
    //                        if let uiImage = UIImage(contentsOfFile: inFullPath) {
    //                            Image(uiImage: uiImage)
    //                                .resizable()
    //                                .frame(width: 40, height: 40)
    //                                .clipShape(Circle())
    //                        }
    //                        else {
    //                            Image("placeholder")
    //                                .resizable()
    //                                .frame(width: 40, height: 40)
    //                        }
                            Image("p1")
                            
                            Text(dashboardModel.AttTm)
                                .font(.subheadline)
                            Image("marker")
                                .frame(width: 10, height: 10)
                                .padding(.top, 3)
                            Button(action: {
                                let latAndLong = dashboardModel.GeoIn
                                let components = latAndLong.split(separator: ",")
                                
                                if components.count == 2,
                                   let lat = Double(components[0]),
                                   let long = Double(components[1]) {
                                    
                                    selectedCoordinate = Coordinate(latitude: lat, longitude: long)
                                    showMap = true
                                }
                            }) {
                                Text("View")
                                    .foregroundColor(Color.appPrimary3)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.top, -5)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    // OUT Time (conditional)
                    if dashboardModel.ET != "00:00:00" {
                        VStack(alignment: .leading) {
                            Text("OUT time")
                                .font(.system(size: 15))
                                .fontWeight(.heavy)
                                .foregroundColor(.gray)
                            
                            HStack {
    //                            let outFullPath = getFullPath(for: dashboardModel.OutTimeImageStr)
    //                            //print("OUT time image full path: \(outFullPath)")
    //
    //                            if let uiImage = UIImage(contentsOfFile: outFullPath) {
    //                                Image(uiImage: uiImage)
    //                                    .resizable()
    //                                    .frame(width: 40, height: 40)
    //                                    .clipShape(Circle())
    //                            }
    //                            else {
    //                                Image("placeholder")
    //                                    .resizable()
    //                                    .frame(width: 40, height: 40)
    //                            }
                                Image("p1")
                                Text(dashboardModel.ET)
                                    .font(.subheadline)
                                Image("marker")
                                    .frame(width: 10, height: 10)
                                    .padding(.top, 3)
                                Button(action: {
                                    print("In Time Button is called")
                                }) {
                                    Text("View")
                                        .foregroundColor(Color.appPrimary3)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .padding(.top, -5)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 30)
                
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(colorData.shared.Background_color2)
                    .cornerRadius(5.0)
                    .padding(.horizontal, 60)
            }
            .onAppear {
                Task {
                    await dashboardModel.getTodayData()
                }
            }
            .navigationDestination(isPresented: $showMap) {
                if let coordinate = selectedCoordinate {
                    MapView(latitude: coordinate.latitude, longitude: coordinate.longitude)
                }
            }
        }
    }
    
    //MARK: - Helper to get full path in Documents
    private func getFullPath(for relativePath: String) -> String {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDir.appendingPathComponent(relativePath).path
    }
}

struct Coordinate: Identifiable, Hashable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}

