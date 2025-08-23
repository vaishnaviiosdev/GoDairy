//
//  DynamicHeight.swift
//  GoDairy
//
//  Created by San eforce on 26/11/24.
//

import SwiftUI

struct DynamicDetentHeight: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        switch context.dynamicTypeSize {
        case .accessibility1:
            return 120
        case .accessibility2:
            return 140
        case .accessibility3:
            return 160
        case .accessibility4:
            return 180
        case .accessibility5:
            return 200
        default:
            return 100
        }
    }
}

extension PresentationDetent {
    static let dynamicDetent = Self.custom(DynamicDetentHeight.self)
}
