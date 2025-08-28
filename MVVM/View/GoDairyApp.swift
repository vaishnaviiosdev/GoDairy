////
////  GoDairyApp.swift
////  GoDairy
////
////  Created by San eforce on 07/08/24.
////
//
//import SwiftUI
//
//@main
//struct GoDairyApp: App {
//    
//    @AppStorage("User_Login") var isLoggedIn: Bool = false
//    
//    var body: some Scene {
//        WindowGroup {
//            let isUserLogin = UserDefaults.standard.value(forKey: "User_Login")
//            if isUserLogin as? Bool ?? false {
//                DashboardView()
//            }
//            else {
//                SplashScreenView()//qad-801090
//            }
//        }
//    }
//}

import SwiftUI

// MARK: - App Entry Point
@main
struct GoDairyApp: App {
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}

// MARK: - App Router
class AppRouter: ObservableObject {
    enum RootView {
        case splash
        case privacy
        case permission
        case login
        case loginView
        case dashboard
    }
    
    @Published var root: RootView = .splash
    @AppStorage("User_Login") var isLoggedIn: Bool = false
    @AppStorage("PrivacyPolicy_Accepted") var privacyAccepted: Bool = false
    
    init() {
        decideInitialView()
    }
    
    func decideInitialView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !self.privacyAccepted {
                self.root = .privacy
            }
            else if self.isLoggedIn {
                self.root = .dashboard
            }
            else {
                self.root = .login
            }
        }
    }
    
    func completePrivacyFlow() {
        privacyAccepted = true
        root = .permission
    }
    
    func completePermissionFlow() {
        root = .login
    }
    
    func loginSuccess() {
        isLoggedIn = true
        root = .dashboard
    }
    
    func logout() {
        isLoggedIn = false
        root = .login
    }
}

// MARK: - RootView Switcher
struct RootView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        switch router.root {
        case .splash:
            SplashScreenView()
        case .privacy:
            PrivacyPolicyView()
        case .permission:
            PermissionAskingView()
        case .login:
            ContentView()
        case .loginView:
            Login_Page_View()
        case .dashboard:
            DashboardView()
        }
    }
}

