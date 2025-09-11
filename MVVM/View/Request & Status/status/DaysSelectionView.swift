//
//  DaysSelectionView.swift
//  GoDairy
//
//  Created by San eforce on 09/09/25.
//

import SwiftUI

struct DaysSelectionView: View {
    @Binding var isPresented: Bool
    let items: [(title: String, days: Int)] = [
        ("Last 7 days", 7),
        ("Last 30 days", 30)
    ]
    var onDateSelected: (Date, Date) async -> Void = { _, _ in }

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }
            
            VStack(spacing: 0) {
                HeaderView(title: "Select Quick Dates")
                
                Divider()
            
                VStack(spacing: 0) {
                    ForEach(items, id: \.title) { item in
                        Button(action: {
                            let toDate = Date()
                            let fromDate = Calendar.current.date(byAdding: .day, value: -item.days, to: toDate)!
                            Task {
                                await onDateSelected(fromDate, toDate)
                            }
                            isPresented = false
                        }) {
                            Text(item.title)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        
                        if item.title != items.last?.title {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                
                Divider()
                Spacer().frame(height: 200)
                
                // Close button
                Button(action: { isPresented = false }) {
                    Text("Close")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)   // ⬅️ smaller height
                        .background(Color.appPrimary)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .cornerRadius(12)
            .frame(maxWidth: 350)
        }
    }
}

// MARK: - Header
struct HeaderView: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.appPrimary)
            .foregroundColor(.white)
    }
}

#Preview {
    DaysSelectionView(isPresented: .constant(true)) { fromDate, toDate in
        print("From: \(fromDate), To: \(toDate)") // ✅ Preview test for dates
    }
}
