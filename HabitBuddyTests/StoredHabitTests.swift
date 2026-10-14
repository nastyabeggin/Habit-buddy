//
//  StoredHabitTests.swift
//  HabitBuddyTests
//

import SwiftUI
import Testing
@testable import HabitBuddy

@Suite("StoredHabit")
@MainActor
struct StoredHabitTests {
    @Test("the Color convenience init stores the colour as hex and sorts the selected days")
    func convenienceInitNormalisesItsInput() {
        let habit = StoredHabit(
            title: "Reading",
            subtitle: "20 pages",
            color: Color(hex: "#9DC345"),
            iconName: "book.fill",
            selectedDays: [6, 2, 4]
        )

        #expect(habit.colorHex == "#9DC345")
        #expect(habit.selectedDays == [2, 4, 6])
    }

    @Test("a newly created habit starts with no completions")
    func newHabitHasNoCompletions() {
        let habit = makeHabit(title: "Running", selectedDays: [2])

        #expect(habit.completions?.isEmpty == true)
    }

    @Test("toHabit carries identity and presentation fields across unchanged")
    func toHabitMapsEveryDisplayedField() {
        let stored = makeHabit(title: "Coding", selectedDays: [3], colorHex: "#FC8FC6", iconName: "curlybraces.square")
        let habit = stored.toHabit()

        #expect(habit.id == stored.id)
        #expect(habit.title == stored.title)
        #expect(habit.subtitle == stored.subtitle)
        #expect(habit.iconTitle == stored.iconName)
        #expect(habit.foregroundColorHex.toHex() == stored.colorHex)
    }
}
