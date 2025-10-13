//
//  Toast message.swift
//  GoDairy
//
//  Created by Mani V on 28/09/24.
//

import SwiftUI
import Combine

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    @Published var isShowing: Bool = false
    var message: String = ""
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        self.message = message
        self.isShowing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isShowing = false
        }
    }
}

struct Toast: View {
    @ObservedObject var toastManager: ToastManager
    var body: some View {
        if toastManager.isShowing {
            Text(toastManager.message)
                .font(.body)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: toastManager.isShowing)
        }
    }
}

struct RoundedCorners: View {
    var color: Color = .white
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let w = geometry.size.width
                let h = geometry.size.height

                // Top Left
                let tl = min(min(self.tl, h/2), w/2)
                // Top Right
                let tr = min(min(self.tr, h/2), w/2)
                // Bottom Left
                let bl = min(min(self.bl, h/2), w/2)
                // Bottom Right
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr),
                            radius: tr,
                            startAngle: Angle(degrees: -90),
                            endAngle: Angle(degrees: 0),
                            clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br),
                            radius: br,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 90),
                            clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl),
                            radius: bl,
                            startAngle: Angle(degrees: 90),
                            endAngle: Angle(degrees: 180),
                            clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl),
                            radius: tl,
                            startAngle: Angle(degrees: 180),
                            endAngle: Angle(degrees: 270),
                            clockwise: false)
            }
            .fill(self.color)
        }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 5)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .animation(.easeInOut(duration: 0.3), value: message)
    }
}


