//
//  Date+Extension.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import Foundation

extension Date {
    private var calendar: Calendar { .current }
    var startOfDay: Date { calendar.startOfDay(for: self) }

    /// The seven days of the week containing this date, starting at the
    /// locale's first weekday.
    var currentWeek: [Date] {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: startOfDay) else { return [] }
        return (0 ..< 7).compactMap { calendar.date(byAdding: .day, value: $0, to: interval.start) }
    }

    var nextWeek: [Date] {
        guard let lastDay = currentWeek.last,
              let dayInNextWeek = Calendar.current.date(byAdding: .day, value: 1, to: lastDay)
        else { return [] }
        return dayInNextWeek.currentWeek
    }

    var previousWeek: [Date] {
        guard let firstDay = currentWeek.first,
              let dayInPreviousWeek = Calendar.current.date(byAdding: .day, value: -1, to: firstDay)
        else { return [] }
        return dayInPreviousWeek.currentWeek
    }

    /// Foundation weekday number: 1 = Sunday ... 7 = Saturday.
    var weekday: Int {
        Calendar.current.component(.weekday, from: startOfDay)
    }
}

extension Date: @retroactive Identifiable {
    public var id: Double {
        timeIntervalSince1970
    }
}
