//
//  OrdersView.swift
//  GoDairy
//
//  Created by San eforce on 13/10/25.
//

import SwiftUI

struct OrdersView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 0) {
                    homeBarTop(frameSize: 50)
                        .padding(.top)
                    homeBarBottom()
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            
                            CustomDropdownButton(title: "SAI PRASANNA(105005)", fontSize: 17, fontWeight: .bold) {
                                print("Tapped dropdown")
                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct homeBarTop: View {
    var frameSize: CGFloat = 40
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("GoDiary")
                    .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)
                    
                Text("Version v3.4")
                    .regularTextStyle(size: 11, foreground: .white, fontWeight: .heavy)
            }
            .padding(.vertical, 5)
            Spacer()
            
            Text("VIEW HISTORY")
                .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)

            NavigationLink(destination: DashboardView()) {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
            }
        }
        .frame(height: frameSize)
        .background(Color.appPrimary)
    }
}

struct homeBarBottom: View {
    var body: some View {
        HStack {
            Text("PRIMARY ORDER")
                .regularTextStyle(size: 21, foreground: .white, fontWeight: .heavy)
                .padding(.leading, 2)
            
            Text("Milk")
                .regularTextStyle(size: 13, foreground: .white, fontWeight: .heavy)
            
            Spacer()
            
            Text("17:30:13  /  13:00:00 ")
                .regularTextStyle(size: 15, foreground: .white, fontWeight: .heavy)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 30)
        .background(Color.appPrimary)
    }
}

#Preview {
    OrdersView()
}
