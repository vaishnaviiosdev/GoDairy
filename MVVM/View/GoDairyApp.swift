//
//  GoDairyApp.swift
//  GoDairy
//
//  Created by San eforce on 07/08/24.
//

import SwiftUI

@main
struct GoDairyApp: App {
    var body: some Scene {
        WindowGroup {
            let isUserLogin = UserDefaults.standard.value(forKey: "User_Login")
            if isUserLogin as? Bool ?? false {
                DashboardView()
            }
            else {
                SplashScreenView()
            }
        }
    }
}
