//
//  TestSupport.swift
//  HabitBuddyTests
//

import Foundation
import SwiftData
@testable import HabitBuddy

/// Points the shared `HabitStorageService` at a throwaway in-memory SwiftData
/// store. This is the real store, not a stub: the tests exercise actual
/// persistence, predicates and cascade rules.
///
/// The returned container must be held for the lifetime of the test.
@MainActor
func makeInMemoryStore() throws -> ModelContainer {
    let schema = Schema([StoredHabit.self, HabitCompletion.self])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: schema, configurations: [configuration])
    HabitStorageService.initialize(with: container.mainContext)
    return container
}

/// A fixed date in the current calendar. 20 September 2026 is a Sunday, so
/// 20...26 September 2026 covers a full Sunday-to-Saturday span.
func testDate(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12, minute: Int = 0) -> Date {
    let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    return Calendar.current.date(from: components)!
}

func makeHabit(
    title: String,
    selectedDays: [Int],
    colorHex: String = "#F8CE63",
    iconName: String = "book.fill",
    createdAt: Date = Date()
) -> StoredHabit {
    StoredHabit(
        title: title,
        subtitle: "subtitle for \(title)",
        colorHex: colorHex,
        iconName: iconName,
        selectedDays: selectedDays,
        createdAt: createdAt
    )
}
