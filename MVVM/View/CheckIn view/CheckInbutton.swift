//
//  CheckInbutton.swift
//  GoDairy
//
//  Created by San eforce on 02/12/24.
//

import SwiftUI

struct CheckInbutton: View {
    var body: some View {
        Text("Check IN")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.black)
        Spacer()
        MapLocation()
    }
}

#Preview {
    CheckInbutton()
}
