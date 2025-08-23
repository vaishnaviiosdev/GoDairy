//
//  forgetpass.swift
//  GoDairy
//
//  Created by San eforce on 07/11/24.
//

import SwiftUI

struct forgetpass: View {
    
    @State private var login: String = ""
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        TextField("",text: $login)
            .font(.system(size: 13,weight: .thin))
            .foregroundColor(.secondary)
            .frame(height: 15,alignment: .leading)
    }
}

#Preview {
    forgetpass()
}
