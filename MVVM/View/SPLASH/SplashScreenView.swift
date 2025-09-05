//
//  SplashScreenView.swift
//  GoDairy
//
//  Created by San eforce on 21/08/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Image("gd3")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    SplashScreenView()
}





