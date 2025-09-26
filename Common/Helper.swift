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

extension DateFormatter {
    static let leaveDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        return formatter
    }()
}

extension Date {
    func formattedAsYYYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

func formatShiftTime(start: String, end: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    inputFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "h.mm a"
    outputFormatter.amSymbol = "AM"
    outputFormatter.pmSymbol = "PM"
    outputFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    
    guard let startDate = inputFormatter.date(from: start),
          let endDate = inputFormatter.date(from: end) else {
        return ""
    }
    
    let startString = outputFormatter.string(from: startDate)
    let endString = outputFormatter.string(from: endDate)
    
    return "\(startString) - \(endString)"
}







