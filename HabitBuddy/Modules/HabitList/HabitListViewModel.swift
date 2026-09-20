//
//  HabitListViewModel.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 20.08.2025.
//

import SwiftUI

@MainActor
@Observable final class HabitListViewModel {

    // MARK: - Properties

    var state: HabitListViewState
    var selectedDate: Date = Calendar.current.startOfDay(for: .now) {
        didSet {
            updateHabitsForSelectedDate()
        }
    }
    var habits: [StoredHabit] = []

    // MARK: - Lifecycle

    init() {
        state = .loading
        loadData()
    }

    // MARK: - Public

    func loadData() {
        updateHabitsForSelectedDate()
    }

    func updateHabitsForSelectedDate() {
        let storedHabits = HabitStorageService.shared.loadHabits(for: selectedDate.weekday)
        self.habits = storedHabits

        if storedHabits.isEmpty {
            state = .loaded(HabitListDisplayData(name: "Anastasiya", selectedDate: selectedDate, cards: []))
        } else {
            let cards = storedHabits.map { habit in
                CardDisplayData(
                    title: habit.title,
                    subtitle: habit.subtitle,
                    foregroundColor: Color(hex: habit.colorHex),
                    icon: Image(systemName: habit.iconName)
                )
            }
            state = .loaded(HabitListDisplayData(name: "Anastasiya", selectedDate: selectedDate, cards: cards))
        }
    }

    func getHabit(at index: Int) -> StoredHabit? {
        guard index < habits.count else { return nil }
        return habits[index]
    }
}
