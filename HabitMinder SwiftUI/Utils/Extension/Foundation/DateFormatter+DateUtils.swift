//
//  DateFormatter+DateUtils.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/28/24.
//

import Foundation

enum DateFormat: String {
    case fullDateTime = "yyyy-MM-dd HH:mm:ss"
    case dateOnly = "yyyy-MM-dd"
    case timeOnly = "HH:mm"
}

extension DateFormatter {
    static func date(from string: String, format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: string)
    }
    
    static func string(from date: Date, format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}
