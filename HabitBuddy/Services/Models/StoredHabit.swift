//
//  StoredHabit.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 24.12.2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class StoredHabit {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String
    var colorHex: String
    var iconName: String
    /// Foundation weekday numbers (1 = Sunday ... 7 = Saturday).
    var selectedDays: [Int]
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
    var completions: [HabitCompletion]?

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        colorHex: String,
        iconName: String,
        selectedDays: [Int],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.colorHex = colorHex
        self.iconName = iconName
        self.selectedDays = selectedDays
        self.createdAt = createdAt
        self.completions = []
    }

    convenience init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        color: Color,
        iconName: String,
        selectedDays: Set<Int>
    ) {
        self.init(
            id: id,
            title: title,
            subtitle: subtitle,
            colorHex: color.toHex(),
            iconName: iconName,
            selectedDays: Array(selectedDays).sorted(),
            createdAt: Date()
        )
    }
}

// MARK: - Conversion Helpers

extension StoredHabit {
    func toHabit() -> Habit {
        Habit(
            id: id,
            title: title,
            subtitle: subtitle,
            foregroundColorHex: Color(hex: colorHex),
            iconTitle: iconName,
            isCompleted: false
        )
    }

    var color: Color {
        Color(hex: colorHex)
    }
}
