//
//  MonthlyPlan.swift
//  GoDairy
//
//  Created by San eforce on 09/10/24.
//

import SwiftUI

struct MonthlyPlan: View {
    var body: some View {
        VStack{
            Text("Monthly Plan")
                .foregroundColor(.black)
            Spacer()
            CalendarView()
            Spacer()
            Divider()
            
            VStack{
                HStack{
                    //Spacer()
                    Rectangle()
                        .frame(width: 5,height: 82)
                        .cornerRadius(3.0)
                        .foregroundColor(colorData.shared.check_out_color)
                    
                    HStack{
                        Text("Leave")
                            .padding()
                        Spacer()
                        Image(systemName: "pen")
                        Text("Edit")
                        // .foreground(Color.orange.opacity(0.1))
                            .padding()
                    }
                    
                    HStack{
                        Text("Fever")
                            .padding()
                        Spacer()
                        Text("01/08/2023")
                            .padding()
                    }
                    
                }
            }
            .frame(width: 380,height: 100)
            .background(Color.orange.opacity(0.3))
            .cornerRadius(5.0)
            Spacer()
            .padding(150)
            .frame(maxWidth: .infinity)
            .padding(30)
           // .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        
        }
    }
}

#Preview {
    MonthlyPlan()
}
