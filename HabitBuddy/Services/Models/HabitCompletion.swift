//
//  HabitCompletion.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 24.12.2025.
//

import Foundation
import SwiftData

@Model
final class HabitCompletion {
    @Attribute(.unique) var id: UUID
    var completedAt: Date
    var completionDate: Date

    var habit: StoredHabit?

    init(
        id: UUID = UUID(),
        completedAt: Date = Date(),
        completionDate: Date,
        habit: StoredHabit? = nil
    ) {
        self.id = id
        self.completedAt = completedAt
        self.completionDate = completionDate
        self.habit = habit
    }

    convenience init(for habit: StoredHabit, on date: Date = Date()) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        self.init(
            completedAt: Date(),
            completionDate: startOfDay,
            habit: habit
        )
    }
}
