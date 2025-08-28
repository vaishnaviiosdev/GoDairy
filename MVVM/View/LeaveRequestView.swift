
//  LeaveRequestView.swift
//  GoDairy
//
//  Created by San eforce on 07/01/25.


import SwiftUI

struct LeaveRequestView: View {
    @State private var LeaveType = ""
    @State private var FromDate : Date = Date()
    @State private var ToDate : Date = Date()
    @State private var numberOfDays: Int = 0
    @State private var reason = ""
    @State private var navigatetoDashboard = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .center,spacing: 0) {
                   // Form{
                       // Section(header: Text("Type of leave")){
                    
//                    TextField(text: $username, prompt: Text("Required")) {
//                            Text("Username")
//                        }
                    Text("Type of leave")
                        .foregroundColor(.black)
                    TextField(text: $LeaveType,prompt: Text(" leave type")) {
//                        Text("Type of leave")
//                            .foregroundColor(.black)
                    }
                       
                       // }
                    Spacer()
                        HStack{
                            VStack{
                                Text("From Date")
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $FromDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 1)
                            }
                            Spacer()
                            VStack{
                            Text("To Date")
                                    .foregroundColor(.secondary)
                            DatePicker("", selection: $ToDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                                }
                            
                        }
                    Spacer()
                        VStack(alignment: .leading,spacing: 0) {
                            Text("No of days")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity,alignment: .center)
                                .padding()
                                .background(Color("App_Primary"))
                            Text("\(numberOfDays)")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                        }
                        .background(Color.white)
                        .cornerRadius(14)
                        .padding(.horizontal)
                        .shadow(radius: 3)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Reason for leave:")
                                .foregroundColor(.gray)
                            TextEditor(text:$reason )
                                .frame(height: 100)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Leave Availablity Status")
                                .foregroundColor(.green)
                            Grid {
                                GridRow {
                                    Text("Type")
                                    Text("Eligibility")
                                    Text("Taken")
                                    Text("Available")
                                }
                                .bold()
                                
                                Divider()
                            }
                        }
                        
                        Button(action:{
                            
                        }){
                            HStack{
                                //Image(systemName: "left.arrow")
                                Text("SUBMIT")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .background(Color("App_Primary"))
                            }
                        }
                    //}
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("LEAVE REQUEST")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: checkInDashboard(),isActive: $navigatetoDashboard) {
                        EmptyView()
                        Spacer()
                        Image(systemName: "house.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color("App_Primary"), for: .navigationBar)
        }
        
        .toolbarBackground(Color("App_Primary"),for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        
       // .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
    }
}

#Preview {
    LeaveRequestView()
}


