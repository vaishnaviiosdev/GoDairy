//
//  MIssedPunchview.swift
//  GoDairy
//
//  Created by San eforce on 26/12/24.
//

import SwiftUI

struct MIssedPunchview: View {
    @State private var missedpunchdate: String = ""
    @State private var shiftTime: String = ""
    @State private var checkInTime: String = ""
    @State private var checkOutDateTime: String = ""
    @State private var reason: String = ""
    
   
    
    var body: some View {
        NavigationStack{
            
            Text("Missed Punch Entry")
                
            Spacer(minLength: 40)
            VStack(spacing: 50){
              
                    
                    VStack(alignment: .leading,spacing: 8){
                        Section(header: Text("Missed Punch Date")) {
                                 TextField("Select Date", text: $missedpunchdate)
                                 
                               }
                    }
                   
                    VStack(alignment: .leading,spacing: 8){
                        Section(header: Text("Shift time")) {
                                 TextField("", text: $shiftTime)
                                 
                               }
                    }
                    
                    
                    
                    VStack(alignment: .leading,spacing: 8){
                       
                        Section(header: Text("Check-in time")) {
                                 TextField("", text: $checkInTime)
                                 
                               }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Section(header: Text("Check-out time and Date")) {
                                 TextField("Select Time and Date", text: $checkOutDateTime)
                                 
                               }
                    }
                    
                    VStack(alignment: .leading,spacing: 8){
                        Section(header: Text("Reason")) {
                                 TextEditor( text: $reason)
                                .frame(height: 100)
                                .background(Color.gray)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .foregroundColor(.white)
//                                )
                                 
                               }
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        
                    }){
                        Text("SUBMIT")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("App_Primary"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
        
            .padding()
        }
    }
}
#Preview {
    MIssedPunchview()
}
