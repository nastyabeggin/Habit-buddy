//
//  CalendarViewModel.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

@MainActor
class CalendarViewModel: ObservableObject {

    // MARK: - Properties

    @Published var selectedDate: Date
    @Published private(set) var week: Week
    /// stub для отметок «выполнено/нет»
    /// в реальности заполнится при запросе на бэкенд
    @Published var habitStatus: [Date: Bool] = [:]

    // MARK: - Lifecycle

    init() {
        let today = Calendar.current.startOfDay(for: .now)
        selectedDate = today
        week = Week(dates: today.currentWeek)
        self.habitStatus = Dictionary(uniqueKeysWithValues: week.dates.map { ($0.startOfDay, $0 < Date()) })
    }

    // MARK: - Public

    func isHabitDone(on date: Date) -> Bool {
        habitStatus[date.startOfDay] ?? false
    }
}
