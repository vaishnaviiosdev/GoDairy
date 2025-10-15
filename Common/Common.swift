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
    var foregroundColour: Color = .appPrimary1
    var frameSize: CGFloat = 20
    
    var body: some View {
        Button(action: action) {
            Image("refresh1")
                .resizable()
                //.font(.system(size: 20, weight: .semibold))
                .frame(width: frameSize, height: frameSize)
                .fontWeight(.bold)
                .foregroundColor(foregroundColour)
                //.regularTextStyle(size: 20, foreground: foregroundColour, fontWeight: .semibold)
                .padding(.leading, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CardStyleModifier: ViewModifier {
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = .white
    var borderColor: Color = Color.black.opacity(0.2) //0.5
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
                    .stroke(borderColor, lineWidth: 0.5) //0.1
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

struct StatusSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            content
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct StatusBaseCard<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 5)
    }
}

struct BorderedTabModifier: ViewModifier {
    var isSelected: Bool
    var selectedColor: Color = .blue
    var unselectedColor: Color = .secondary
    var cornerRadius: CGFloat = 12
    var lineWidth: CGFloat = 2
    var leadingPadding: CGFloat = 0
    var verticalPadding: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.leading, leadingPadding)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, 10)
            
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isSelected ? selectedColor : unselectedColor, lineWidth: lineWidth)
            )
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func borderedTab(isSelected: Bool, selectedColor: Color = .blue, leading: CGFloat = 12, vertical: CGFloat = 8, cornerR: CGFloat = 12) -> some View {
        self.modifier(BorderedTabModifier(isSelected: isSelected, selectedColor: selectedColor, cornerRadius: cornerR, leadingPadding: leading, verticalPadding: vertical))
    }
}



