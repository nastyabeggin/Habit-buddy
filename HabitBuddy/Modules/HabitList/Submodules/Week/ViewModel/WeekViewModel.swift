//
//  WeekViewModel.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

@MainActor
class WeekViewModel: ObservableObject {
    // MARK: - Properties

    /// Per-day completion marks, keyed by start of day.
    @Published var habitStatus: [Date: Bool] = [:]

    // MARK: - Public

    func isHabitDone(on date: Date) -> Bool {
        habitStatus[date.startOfDay] ?? false
    }

    func update(for selectedDate: Date) {
        let week = selectedDate.currentWeek
        habitStatus = Dictionary(uniqueKeysWithValues: week.map { date in
            (date.startOfDay, isDayComplete(date))
        })
    }

    // MARK: - Private

    /// A day counts as done once every habit scheduled for it is completed.
    private func isDayComplete(_ date: Date) -> Bool {
        let storage = HabitStorageService.shared
        let habits = storage.loadHabits(for: date.weekday)
        guard !habits.isEmpty else { return false }
        return habits.allSatisfy { storage.isHabitCompleted($0, on: date) }
    }
}
