//
//  PermissionAskingView.swift
//  GoDairy
//
//  Created by San eforce on 19/08/25.
//

import SwiftUI

struct PermissionAskingView: View {
    
    @State private var showAlert = false
    @State private var navigateToHome = false
    @StateObject private var permissionManager = PermissionManager()
    
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 30) {
            Image("circle")
                .resizable()
                .frame(width: 120, height: 120)
            Text("Precise & Background Location permission required")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Allow GODIARY App to automatically detect your current location for travel allowance and Collects Location data to enable identification of near by outlets even when the app is closed or not in use")
                .fontWeight(.medium)
                .foregroundColor(.gray)
            Text("To enable, go to 'Settings' and set Location permission as 'Allow all the time' and turn on 'Use precise Location' ")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .fontWeight(.medium)
            
                CustomBtn(title: "OPEN SETTINGS", height: 40, backgroundColor: Color.appPrimary) {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                .padding(.horizontal, 8)//qad-801090
           // }
        }
        .onAppear {
            permissionManager.requestAllPermissionsSequentially()
        }
        .onChange(of: permissionManager.locationGranted) { granted in
            print("The locationGranted granted is \(granted)")
            if granted {
                router.completePermissionFlow()
               // navigateToHome = true
            }
        }
//        .navigationDestination(isPresented: $navigateToHome) {
//            ContentView()
//        }
        .padding(5)
    }
}

#Preview {
    PermissionAskingView()
}

//struct PermissionAskingView: View {
//    @EnvironmentObject var router: AppRouter
//    
//    var body: some View {
//        VStack {
//            Text("Ask permissions here")
//            Button("Allow & Continue") {
//                router.completePermissionFlow()
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//        }
//    }
//}

