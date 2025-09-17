//
//  forgetpass.swift
//  GoDairy
//
//  Created by San eforce on 07/11/24.
//

import SwiftUI

struct forgetpass: View {
    @State private var showingSheet = false
    @State private var login: String = ""
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            CenteredImageView()
        }
    }
}

struct CenteredImageView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("Group 17")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    forgetpass()
}
