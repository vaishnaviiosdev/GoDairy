//
//  PrivacyPolicyView.swift
//  GoDairy
//
//  Created by San eforce on 19/08/25.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
//    @State private var isActive = false
//    @State private var isChecked = false
//    @State private var navigateToPermissions = false
//    @AppStorage("PrivacyPolicy_Accepted") var privacyAccepted: Bool = false
    
    @EnvironmentObject var router: AppRouter
    @State private var isChecked = false
    
    var body: some View {
        NavigationStack {
            VStack {
                WebViews().padding(.vertical, 8)
                VStack {
                    HStack {
                        Button(action: {
                            isChecked.toggle()
                        }) {
                            Image(isChecked ? "check-box" : "unchecked")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        Text("Please accept the Privacy Policy")
                            .fontWeight(.medium)
                            .font(.system(size: 12))
                        Spacer()
                    }
                    .padding(5)
                    
                    Button(action: {
                        if isChecked {
////                            privacyAccepted = true
////                            navigateToPermissions = true
////                            //isActive = true
////                            print("Submit accepted ✅")
//                            router.completePrivacyFlow()
//                        }
//                        else {
//                            print("Please accept policy first ❌")
//                        }
                            
                            router.completePrivacyFlow()
                    }
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(isChecked ? Color.appPrimary : Color.appSecondary)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                    }
                    .disabled(!isChecked)
                }
                .frame(height: 80)
                .padding(.vertical, 8)
                
//                NavigationLink(destination: PermissionAskingView(), isActive: $navigateToPermissions) {
//                    EmptyView()
//                }
            }
        }
    }
}

struct WebViews: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: privacy_url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view if needed
    }
}

#Preview {
    PrivacyPolicyView()
}
