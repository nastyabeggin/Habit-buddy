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
    let id = UUID()
    let title: String
    let subtitle: String
    let foregroundColorHex: Color
    let iconTitle: String
    let isCompleted: Bool
}
