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


