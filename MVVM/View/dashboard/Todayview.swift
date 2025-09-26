//
//  Todayview.swift
//  GoDairy
//
//  Created by San eforce on 05/10/24.
//

import SwiftUI
import Alamofire

struct Todayview: View {
    @State private var timeRemaining = 100
    @State var shift_timing: String = ""
    @State var tdyDate: String = "11/07/2023"
    @State private var shiftTimeRange: String = ""
    @StateObject var dashboardModel = dashboardViewModel()
    
    
    let startDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let dateFormatter = Date.FormatStyle(date: .omitted, time: .standard)
    var furtureDate = Date.now.addingTimeInterval(3000)
    
    var body: some View {
            VStack {
                HStack {
                    Text("\(tdyDate)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.leading, 30)
                HStack{
                    Text(Date.now...Date.now.addingTimeInterval(31000))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    Spacer()
                    Image("Late")
                    Text("Late")
                        .font(.system(size: 15)).bold()
                        .foregroundColor(colorData.shared.check_out_color)
                }
                .padding(.leading, 30)
                .padding(.top, 10)
                .padding(.trailing, 30)
                HStack {
                   // Spacer()
                    Text("IN time")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                   Spacer()
                        .frame(width: 160)
              
                    Text("OUT time")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Spacer(minLength: 40)
                }
                .padding(10)
                Spacer()
                    .frame(height: 5)
                HStack{
                    Image("p1")
                    TimelineView(.periodic(from: startDate, by: 1.0)) { context in
                        VStack(spacing: 12){
                            Text(context.date,format: dateFormatter)
                        }
                        .font(.subheadline)
                    }
                    Image("marker")
                        .frame(width: 10, height: 10)
                    Text("view")
                        .foregroundColor(.blue)
                        .font(.system(size: 15))
                    Spacer()
                    Image("p1")
                    TimelineView(.periodic(from: startDate, by: 1.0)) { context in
                        VStack(spacing: 12){
                            Text(context.date,format: dateFormatter)
                        }
                        .font(.subheadline)
                    }
                    Image("marker")
                        .frame(width: 10, height: 10)
                    Text("view")
                        .foregroundColor(.blue)
                        .font(.system(size: 15))
                }
                .padding(.top,2)
                Spacer()
                    .frame(height: 5)
                ZStack{
                    HStack{
                        Spacer()
                            
                        Image("A1")
                        Spacer(minLength: 210)
                        Image("A1")
                        Spacer()
                    }
                    //.padding(4)
                }
                
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 350,height: 4)
                            .foregroundColor(colorData.shared.line_color.opacity(0.3))
                            .cornerRadius(3.0)
                        Rectangle()
                            .frame(width: 220,height: 4)
                            .foregroundColor(Color("App_Primary"))
                            .cornerRadius(5.0)
                    }
                    HStack{
                        Spacer()
                        Text("IN")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Spacer()
                        Text("12:00:00")
                            .foregroundColor(.black)
                        Spacer()
                        Text("OUT")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .padding(2)
               
            }
            .onAppear {
                Task {
                    await dashboardModel.getTodayData()
                    
                    if let start = dashboardModel.todayPlanData[0].TodayData?.Shft?.date,
                       let end = dashboardModel.todayPlanData[0].TodayData?.ShftE?.date {
                                shiftTimeRange = formatShiftTime(start: start, end: end)
                    }
                }
            }
    }
}

#Preview {
    Todayview()
}
