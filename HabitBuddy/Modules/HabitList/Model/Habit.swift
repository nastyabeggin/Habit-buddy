//
//  Habit.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 20.08.2025.
//

import SwiftUI

struct HabitList {
    let habits: [Habit]
}

struct Habit: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let foregroundColorHex: Color
    let iconTitle: String
    let isCompleted: Bool

    init(id: UUID = UUID(), title: String, subtitle: String, foregroundColorHex: Color, iconTitle: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.foregroundColorHex = foregroundColorHex
        self.iconTitle = iconTitle
        self.isCompleted = isCompleted
    }
}
