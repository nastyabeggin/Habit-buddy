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

    var currentWeek: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: today) - (calendar.firstWeekday - 1)
        let range = calendar.range(of: .weekday, in: .weekOfYear, for: today)
        let dates = range?.compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return dates ?? []
    }

    var nextWeek: [Date] {
        guard let lastDay = currentWeek.last else { return [] }
        let calendar = Calendar.current
        let nextWeekDay = calendar.date(byAdding: .day, value: 1, to: lastDay)
        return nextWeekDay?.currentWeek ?? []
    }

    var previousWeek: [Date] {
        guard let lastDay = currentWeek.first else { return [] }
        let calendar = Calendar.current
        let nextWeekDay = calendar.date(byAdding: .day, value: -calendar.firstWeekday, to: lastDay)
        return nextWeekDay?.currentWeek ?? []
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
