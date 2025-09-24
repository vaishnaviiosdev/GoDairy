//
//  Gate in:out.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI

struct Gate_in_out: View {
    @State var SliderValue: Float = 0.0
    var body: some View {
        Text("Hello, Gate_in_out!")
        Spacer()
            .frame(height: 50)
        Text("world")
        
       /* Slider(value: $SliderValue, in: 0...10,step:2){ didChange in
            print("Did change:\(didChange)")
        }.padding()*/
    }
}

#Preview {
    ResponsiveCircleView()
}

struct ResponsiveCircleView: View {
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(Color.blue)
                .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .background(Color.gray.opacity(0.2)) // Background to see the bounds
    }
}
