//
//  CreateHabitViewModel.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 17.09.2025.
//

import SwiftUI

@MainActor
@Observable final class CreateHabitViewModel {
    // MARK: - Properties

    var state: CreateHabitViewState

    var canSave: Bool {
        !state.habit.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !state.days.isEmpty
    }

    // MARK: - Lifecycle

    init() {
        state = CreateHabitViewState.defaultState
    }

    // MARK: - Public

    func saveHabit() {
        let habit = StoredHabit(
            title: state.habit.value.trimmingCharacters(in: .whitespacesAndNewlines),
            subtitle: state.description.value.trimmingCharacters(in: .whitespacesAndNewlines),
            color: state.foregroundColor,
            iconName: state.iconName,
            selectedDays: state.days
        )

        HabitStorageService.shared.saveHabit(habit)
    }
}
