//
//  Common.swift
//  GoDairy
//
//  Created by San eforce on 08/10/25.
//

import Foundation
import SwiftUICore

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
