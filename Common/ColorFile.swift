//
//  ColorFile.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import Foundation
import SwiftUI

class colorData {
    static var shared = colorData()
    var Appcolor: Color =  Color(red:25/255,green: 151/255,blue: 206/255)
    var Background_color:Color = Color(red: 0.97, green: 0.97, blue: 0.97, opacity: 1.00)
    var Background_color2:Color = Color(red: 203/255, green: 203/255, blue: 203/255)
    var check_out_color:Color = Color(red:211/255, green: 84/255, blue: 0/255)
    
    var line_color:Color = Color(red:211/255, green:211/255, blue: 211/255)
    var app_primary = Color(red:43/255,green: 136/255,blue: 190/255)
    var app_primary1 = Color(red:54/255,green: 152/255,blue: 231/255)
    var app_primary3 = Color(red:47/255,green: 149/255,blue: 204/255)
    var app_backgroundPink = Color(red:242/255,green: 233/255,blue: 234/255)
    var appPrimary_Button = Color(red:54/255,green: 112/255,blue: 236/255)
    var acceptBtn = Color(red:18/255,green: 94/255,blue: 95/255)
    var rejectBtn = Color(red:172/255,green: 32/255,blue: 53/255)
    var Cancel_Background = Color(red:172/255,green: 32/255,blue: 53/255)
    var app_primary2 = Color(red:218/255,green: 96/255,blue: 11/255)
}

extension Color {
    init?(cssRGB: String) {
        // Remove !important or extra spaces
        let cleaned = cssRGB
            .lowercased()
            .replacingOccurrences(of: "!important", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Regex to capture rgb(r, g, b)
        let pattern = #"rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned)),
              match.numberOfRanges == 4 else {
            return nil
        }
        
        func component(_ index: Int) -> Double {
            if let range = Range(match.range(at: index), in: cleaned),
               let value = Double(cleaned[range]) {
                return value / 255.0
            }
            return 0
        }
        
        let red = component(1)
        let green = component(2)
        let blue = component(3)
        
        self = Color(red: red, green: green, blue: blue)
    }
}


