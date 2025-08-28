//
//  LeaveView.swift
//  GoDairy
//
//  Created by San eforce on 25/08/25.
//

import SwiftUI

struct LeaveView: View {
    var body: some View {
        NavigationStack {
            VStack {
                homeBar()
                ScrollView {
                    LeaveSectionCard(title: "LEAVE REQUEST")
                }
            }
        }
    }
}

struct LeaveSectionCard: View {
    let title: String
    @State private var textValue = ""
    @State private var isHalfDaySelected = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleCard(title: title, frameHeight: 40, fontSize: 14)
            
            CustomCard(title: "Type of Leave",placeholderString: "Select the leave type") {
                
            }
            
            HStack {
                CustomCard(title: "From Date", placeholderString: "Select from date") {
                    
                }
                CustomCard(title: "To Date", placeholderString: "Select to date") {
                    
                }
            }
            
            HStack {
                daysView()
                halfdayView(isHalfDaySelected: $isHalfDaySelected)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            if isHalfDaySelected {//Show Only when user selected half day
                CustomCard(title: "Shift Timing",placeholderString: "Shift Timing") {
                    
                }
                CustomCard(title: "Type of Half-Day",placeholderString: "Halfday Type") {
                    
                }
            }
            
            titleView(title: "Reason for leave:")
            
            CustomTextView(text: $textValue, placeholder: "Reason for leave")
                .padding(.horizontal, 8)
                .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct daysView: View {
    @State private var numberOfDays: Int = 0
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            titleCard(title: "No of days", frameHeight: 30, fontSize: 13)
            Text("\(numberOfDays)")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.green)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .padding(.vertical, 8)
                .background(Color.white)
                .shadow(radius: 1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 8)
        .shadow(radius: 3)
    }
}

struct halfdayView: View {
    @Binding var isHalfDaySelected: Bool
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            titleCard(title: "Half day", frameHeight: 30, fontSize: 13)
            ZStack {
                Button(action: {
                    isHalfDaySelected.toggle()
                }) {
                    Image(isHalfDaySelected ? "check-box" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.vertical, 8)
            .background(Color.white)
            .shadow(radius: 1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 8)
        .shadow(radius: 3)
    }
}

struct titleView: View {
    let title: String
    var body: some View {
        Text(title)
            .foregroundColor(.black)
            .font(.system(size: 13))
            .fontWeight(.light)
            .padding(.leading, 5)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CustomTextView: View {
    @Binding var text: String
    var placeholder: String = "Enter text..."
    var cornerRadius: CGFloat = 8
    var fontSize: CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.system(size: fontSize))
                .padding(.horizontal, 4)
                .padding(.top, 6)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .cornerRadius(cornerRadius)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .frame(minHeight: 100)
            
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: fontSize))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            }
        }
    }
}

struct CustomCard: View {
    let title: String
    let placeholderString: String
    let action: () -> Void // 👈 Pass action here
    
    @State private var selectedValue: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView(title: title)
            
            Button(action: {
                action()
            }) {
                Text(selectedValue ?? placeholderString)
                    .foregroundColor(selectedValue == nil ? .gray : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .font(.system(size: 14))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 0.3)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 5)
        }
        .padding(5)
    }
}

#Preview {
    LeaveView()
}

