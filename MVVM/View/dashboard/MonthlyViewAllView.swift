//
//  MonthlyViewAllView.swift
//  GoDairy
//
//  Created by San eforce on 29/09/25.
//

import SwiftUI

struct MonthlyViewAllView: View {
    
    @StateObject var dashboardVM = dashboardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                homeBar(frameSize: 40)
                
                ScrollView {
                    monthlyViewAllCard(title: "VIEW ALL STATUS", Model: dashboardVM)
                }
                .padding(5)
            }
            .task {
                await dashboardVM.getMonthlyDashboardViewAllData()
            }
        }
        .navigationBarBackButtonHidden()
    }
}


struct monthlyViewAllCard: View {
    let title: String
    @ObservedObject var Model: dashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            monthlyViewAllList(Model: Model)
            
        }
        .background(Color.backgroundColour)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct monthlyViewAllList: View {
    @ObservedObject var Model: dashboardViewModel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVStack(spacing: 20) {
                
                ForEach(Model.monthlyViewallData) { item in
                    
                    monthlyViewAllDataList(item: item)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct monthlyViewAllDataList: View {
    let item: monthlyViewAllData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            //topRow
            Divider().background(.black)
            //shiftAndReason
            //appliedAndStatus
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 0.3))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 5)
    }
    
//    private var topRow: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text(item.WrkDate ?? <#default value#>)
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.black)
//                
//                Spacer()
//                
//                Text(item.DayStatus)
//                    .font(.system(size: 12, weight: .bold))
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 5)
//                    .background(
//                        (item.DayStatus.lowercased() == "leave" || item.DayStatus.lowercased() == "on-time")
//                        ? Color.approved
//                        : Color.reject
//                    )
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//        }
//    }
//    
    private var bottomRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("SHIFT TIME")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.Shft ?? "")
                    .font(.system(size: 14, weight: .semibold))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("IN TIME")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.AttTm ?? "")
                        .font(.system(size: 14, weight: .semibold))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("OUT TIME")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.ET ?? "")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
    }
}


#Preview {
    MonthlyViewAllView()
}
