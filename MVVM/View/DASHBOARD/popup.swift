//
//  popup.swift
//  GoDairy
//
//  Created by San eforce on 15/11/24.
//
import SwiftUI
struct Content: View {
    @State private var showDayPlan = false
    
    var body: some View {
        NavigationStack{
            VStack {
                Button("MY Day Plan") {
                    showDayPlan.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .sheet(isPresented: $showDayPlan, content: {
                ModalView(isPresented: $showDayPlan)
                    .presentationDetents([.height(700)])
            })
            }
        }
    }

#Preview {
    Content()
}
