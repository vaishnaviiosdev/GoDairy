//
//  ColorFile.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import Foundation
import SwiftUI

class colorData{
    static var shared = colorData()
    var Appcolor: Color =  Color(red:25/255,green: 151/255,blue: 206/255)
    var Background_color:Color = Color(red: 0.97, green: 0.97, blue: 0.97, opacity: 1.00)
    var check_out_color:Color = Color(red:211/255, green: 84/255, blue: 0/255)
    
    var line_color:Color = Color(red:211/255, green:211/255, blue: 211/255)
    var app_primary = Color.appPrimary
    var app_primary1 = Color.appPrimary1
    
}
