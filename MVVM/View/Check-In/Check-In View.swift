//
//  Check-In View.swift
//  GoDairy
//
//  Created by San eforce on 22/09/25.
//

import SwiftUI

import SwiftUI

struct CheckInFlowView: View {
    @State private var currentStep = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 🔹 Top Step Indicator Bar
            StepIndicator(currentStep: $currentStep)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
            
            Divider()
            
            // 🔹 Step Content
            VStack {
                if currentStep == 0 {
                    LocationStep {
                        withAnimation { currentStep = 1 }
                    }
                }
                else if currentStep == 1 {
                    ShiftStep {
                        withAnimation { currentStep = 2 }
                    }
                }
                else if currentStep == 2 {
                    SelfieStep {
                        print("✅ Final submit")
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarTitle("Check IN", displayMode: .inline)
    }
}

//struct StepIndicator: View {
//    @Binding var currentStep: Int
//    let steps = ["Location", "Shift", "Selfie"]
//
//    var body: some View {
//        HStack(alignment: .center, spacing: 0) {
//            ForEach(steps.indices, id: \.self) { index in
//                HStack(spacing: 0) {
//                    // 🔹 Step Icon + Label
//                    VStack(spacing: 6) {
//                        if index < currentStep {
//                            Image(systemName: "checkmark.circle.fill") // completed
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                        } else if index == currentStep {
//                            Image("Rounded_Circle") // current (from Assets)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                        } else {
//                            Image(systemName: "circle") // upcoming
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(.gray)
//                        }
//
//                        Text(steps[index])
//                            .font(.caption)
//                            .foregroundColor(index == currentStep ? .black : .gray)
//                            .multilineTextAlignment(.center)
//                    }
//                    .frame(minWidth: 40)
//
//                    // 🔹 Connector bar (only between steps)
//                    if index < steps.count - 1 {
//                        Rectangle()
//                            .fill(currentStep > index ? Color.black : Color.gray.opacity(0.3))
//                            .frame(height: 2)
//                            .frame(maxWidth: .infinity)
//                            .padding(.bottom, 20) // shift bar up to center of circle
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 16)
//    }
//}

struct StepIndicator: View {
    @Binding var currentStep: Int
    let steps = ["Location", "Shift", "Selfie"]

    // tweak these to change sizes/spacing
    private let horizontalInset: CGFloat = 24
    private let circleSize: CGFloat = 24
    private let labelOffset: CGFloat = 18   // distance from circle center to label center
    private let topPadding: CGFloat = 12
    private let barHeight: CGFloat = 2

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let availableWidth = max(0, totalWidth - horizontalInset * 2)
            let stepCount = steps.count
            let spacing = stepCount > 1 ? availableWidth / CGFloat(stepCount - 1) : 0
            let lineY = topPadding + circleSize / 2    // y coordinate for circle centers and connector center

            ZStack {
                // Base (gray) track that spans from first circle center to last circle center
                Rectangle()
                    .fill(Color.gray.opacity(0.28))
                    .frame(width: availableWidth, height: barHeight)
                    .position(x: totalWidth / 2, y: lineY)

                // Filled progress segments (one per gap). We position each filled rect so its center aligns with the connector.
                ForEach(0..<max(0, stepCount - 1), id: \.self) { i in
                    let startX = horizontalInset + CGFloat(i) * spacing
                    let progress = connectorProgress(for: i)   // 0.0 .. 1.0
                    let fillWidth = spacing * progress

                    // Only draw if there is some width to draw
                    if fillWidth > 0 {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: fillWidth, height: barHeight)
                            .position(x: startX + fillWidth / 2, y: lineY)
                            .animation(.easeInOut, value: currentStep)
                    }
                }

                // Circles (or images) and labels exactly at their computed x positions
                ForEach(steps.indices, id: \.self) { i in
                    let cx = horizontalInset + CGFloat(i) * spacing

                    // icon (use your asset for current step if you want)
                    Group {
                        if i < currentStep {
                            // completed
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.blue)
                        }
                        else if i == currentStep {
                            // current — use your asset name here if you prefer custom image
                            // fallback to system if asset missing
                            if UIImage(named: "Rounded_Circle") != nil {
                                Image("Rounded_Circle")
                                    .resizable()
                            }
                            else {
                                Circle()
                                    .fill(Color.white)
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            }
                        }
                        else {
                            // upcoming
                            Image(systemName: "circle")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: circleSize, height: circleSize)
                    // center of icon at (cx, lineY)
                    .position(x: cx, y: lineY)

                    // label under the circle
                    Text(steps[i])
                        .font(.caption)
                        .foregroundColor(i == currentStep ? .blue : .gray)
                        .multilineTextAlignment(.center)
                        // place label center at lineY + circleRadius + labelOffset
                        .position(x: cx, y: lineY + (circleSize / 2) + labelOffset)
                }
            }
            // keep a fixed height for the indicator (adjust if labels need more space)
            .frame(height:  topPadding + circleSize + labelOffset + 16)
        }
        .frame(height: 80) // makes parent layout simpler — adjust as needed
    }

    /// 0 => empty, 0.5 => half filled, 1 => fully filled
    private func connectorProgress(for index: Int) -> CGFloat {
        if currentStep > index {
            return 1.0   // completed step -> fully filled
        }
        else if currentStep == index {
            return 0.5   // current step -> half filled
        }
        else {
            return 0.0   // upcoming -> empty
        }
    }
}

// 🔹 Step 1: Location
struct LocationStep: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            // replace with MapView if you integrate MapKit/Google Maps
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 300)
                .overlay(Text("Map View"))
                .cornerRadius(8)
                .padding()
            
            Text("No 4, Chennai, Tamil Nadu, India")
                .font(.headline)
            Text("Full address goes here…")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Button("Check-In") {
                onNext()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
    }
}

// 🔹 Step 2: Shift
struct ShiftStep: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("🕒 Select your shift")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Button("Next") { onNext() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
        }
    }
}

// 🔹 Step 3: Selfie
struct SelfieStep: View {
    var onNext: () -> Void
    var body: some View {
        VStack {
            Text("🤳 Take a Selfie")
                .font(.title2)
                .padding()
            
            Spacer()
            
            Button("Submit") { onNext() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
        }
    }
}

#Preview {
    NavigationView {
        CheckInFlowView()
    }
}
