//
//  Helper.swift
//  GoDairy
//
//  Created by San eforce on 28/08/25.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

func areDatesSameDay(_ date1: Date?, _ date2: Date?) -> Bool {
    guard let d1 = date1, let d2 = date2 else { return false }
    return Calendar.current.isDate(d1, inSameDayAs: d2)
}



