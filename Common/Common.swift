//
//  Common.swift
//  GoDairy
//
//  Created by San eforce on 08/10/25.
//

import Foundation
import SwiftUICore
import SwiftUI

struct BackIcon: View {
    var color: Color = .black
    var body: some View {
        Image(systemName: "chevron.left")
            .resizable()
            .frame(width: 13, height: 22)
            .foregroundColor(color)
            .fontWeight(.bold)
    }
}

struct RefreshButton: View {
    var action: () -> Void   // closure for custom tap behavior
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.appPrimary1)
                .regularTextStyle(size: 20, foreground: .appPrimary1, fontWeight: .semibold)
                .padding(.leading, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = .white
    var borderColor: Color = Color.gray.opacity(0.5)
    var shadowColor: Color = Color.black.opacity(0.17)
    var shadowRadius: CGFloat = 4
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 0.1)
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
    }
}

extension View {
    func cardStyle(
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = .white
    ) -> some View {
        self.modifier(CardStyleModifier(cornerRadius: cornerRadius, backgroundColor: backgroundColor))
    }
    
    func regularTextStyle(size: CGFloat = 14, foreground: Color = .black, fontWeight: Font.Weight = .regular) -> some View {
        self.font(.system(size: size)).foregroundColor(foreground).fontWeight(fontWeight)
    }
}
