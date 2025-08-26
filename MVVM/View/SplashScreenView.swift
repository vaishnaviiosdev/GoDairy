//
//  SplashScreenView.swift
//  GoDairy
//
//  Created by San eforce on 21/08/25.
//

import SwiftUI

struct SplashScreenView: View {
   // @State private var isActive = false
    
    var body: some View {
//        if isActive {
//            PrivacyPolicyView()
//        }
//        else {
            ZStack {
                Color.white.ignoresSafeArea()
                Image("gd3") // your logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    withAnimation {
//                        isActive = true
//                    }
//                }
//            }
       // }
    }
}

#Preview {
    SplashScreenView()
}





