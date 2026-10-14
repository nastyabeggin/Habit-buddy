//
//  HabitStorageServiceTests.swift
//  HabitBuddyTests
//

import Foundation
import SwiftData
import Testing
@testable import HabitBuddy

/// Serialized because `HabitStorageService` is a singleton: each test points it
/// at its own in-memory container, so they must not run concurrently.
@Suite("HabitStorageService", .serialized)
@MainActor
struct HabitStorageServiceTests {
    private let container: ModelContainer
    private let storage = HabitStorageService.shared

    init() throws {
        container = try makeInMemoryStore()
    }

    private func storedCompletions() throws -> [HabitCompletion] {
        try container.mainContext.fetch(FetchDescriptor<HabitCompletion>())
    }

    // MARK: - Scheduling

    @Test("loadHabits returns only the habits scheduled for the requested weekday")
    func loadHabitsFiltersByWeekday() {
        storage.saveHabit(makeHabit(title: "Sunday roast", selectedDays: [1]))
        storage.saveHabit(makeHabit(title: "Standup", selectedDays: [2, 3, 4, 5, 6]))

        #expect(storage.loadHabits(for: 1).map(\.title) == ["Sunday roast"])
        #expect(storage.loadHabits(for: 3).map(\.title) == ["Standup"])
        #expect(storage.loadHabits(for: 7).isEmpty)
    }

    /// Regression: the picker and the query used different day numbering, so a
    /// habit saved for a day never came back on that day.
    @Test("a habit saved for a date's weekday is returned when that date is queried")
    func savedWeekdayMatchesTheDateItWasSavedFor() {
        let sunday = testDate(2026, 9, 20)
        let monday = testDate(2026, 9, 21)
        storage.saveHabit(makeHabit(title: "Sunday roast", selectedDays: [sunday.weekday]))

        #expect(storage.loadHabits(for: sunday.weekday).map(\.title) == ["Sunday roast"])
        #expect(storage.loadHabits(for: monday.weekday).isEmpty)
    }

    @Test("a habit scheduled for every day is returned for all seven weekdays")
    func everyDayHabitIsAlwaysReturned() {
        storage.saveHabit(makeHabit(title: "Water", selectedDays: Array(1 ... 7)))

        for weekday in 1 ... 7 {
            #expect(storage.loadHabits(for: weekday).count == 1)
        }
    }

    @Test("habits are returned newest first")
    func habitsAreSortedNewestFirst() {
        storage.saveHabit(makeHabit(title: "Older", selectedDays: [1], createdAt: testDate(2026, 9, 1)))
        storage.saveHabit(makeHabit(title: "Newer", selectedDays: [1], createdAt: testDate(2026, 9, 10)))

        #expect(storage.loadHabits(for: 1).map(\.title) == ["Newer", "Older"])
    }

    // MARK: - Completions

    @Test("marking the same habit and day twice records only one completion")
    func markingTheSameDayTwiceIsIdempotent() throws {
        let habit = makeHabit(title: "Reading", selectedDays: [4])
        storage.saveHabit(habit)
        let day = testDate(2026, 9, 23)

        storage.markHabitCompleted(habit, on: day)
        storage.markHabitCompleted(habit, on: day)

        #expect(try storedCompletions().count == 1)
        #expect(storage.isHabitCompleted(habit, on: day))
    }

    @Test("a completion recorded late at night counts for the whole of that day")
    func completionIsKeyedToTheStartOfTheDay() {
        let habit = makeHabit(title: "Reading", selectedDays: [4])
        storage.saveHabit(habit)

        storage.markHabitCompleted(habit, on: testDate(2026, 9, 23, hour: 23, minute: 30))

        #expect(storage.isHabitCompleted(habit, on: testDate(2026, 9, 23, hour: 7)))
        #expect(!storage.isHabitCompleted(habit, on: testDate(2026, 9, 24, hour: 7)))
    }

    @Test("an untouched habit is not reported as completed")
    func untouchedHabitIsNotCompleted() {
        let habit = makeHabit(title: "Reading", selectedDays: [4])
        storage.saveHabit(habit)

        #expect(!storage.isHabitCompleted(habit, on: testDate(2026, 9, 23)))
    }

    @Test("unmarking clears only the day it was asked about")
    func unmarkingAffectsASingleDay() {
        let habit = makeHabit(title: "Reading", selectedDays: [4, 5])
        storage.saveHabit(habit)
        let wednesday = testDate(2026, 9, 23)
        let thursday = testDate(2026, 9, 24)
        storage.markHabitCompleted(habit, on: wednesday)
        storage.markHabitCompleted(habit, on: thursday)

        storage.unmarkHabitCompleted(habit, on: wednesday)

        #expect(!storage.isHabitCompleted(habit, on: wednesday))
        #expect(storage.isHabitCompleted(habit, on: thursday))
    }

    @Test("one habit's completion does not mark another habit complete")
    func completionsAreScopedToTheirHabit() {
        let reading = makeHabit(title: "Reading", selectedDays: [4])
        let running = makeHabit(title: "Running", selectedDays: [4])
        storage.saveHabit(reading)
        storage.saveHabit(running)
        let day = testDate(2026, 9, 23)

        storage.markHabitCompleted(reading, on: day)

        #expect(storage.isHabitCompleted(reading, on: day))
        #expect(!storage.isHabitCompleted(running, on: day))
    }

    @Test("getCompletionStatus reports a flag for every date it is given")
    func completionStatusCoversEveryRequestedDate() {
        let habit = makeHabit(title: "Reading", selectedDays: [4, 5, 6])
        storage.saveHabit(habit)
        let days = [testDate(2026, 9, 23), testDate(2026, 9, 24), testDate(2026, 9, 25)]
        storage.markHabitCompleted(habit, on: days[1])

        let status = storage.getCompletionStatus(for: habit, dates: days)

        #expect(status.count == days.count)
        #expect(status[days[0].startOfDay] == false)
        #expect(status[days[1].startOfDay] == true)
        #expect(status[days[2].startOfDay] == false)
    }

    // MARK: - Deletion

    @Test("deleting a habit removes it from later queries")
    func deletedHabitIsNoLongerReturned() {
        let habit = makeHabit(title: "Reading", selectedDays: [1])
        storage.saveHabit(habit)

        storage.deleteHabit(id: habit.id)

        #expect(storage.loadHabits(for: 1).isEmpty)
    }

    @Test("deleting a habit cascades to the completions it owns")
    func deletingAHabitCascadesToItsCompletions() throws {
        let habit = makeHabit(title: "Reading", selectedDays: [4])
        storage.saveHabit(habit)
        storage.markHabitCompleted(habit, on: testDate(2026, 9, 23))
        #expect(try storedCompletions().count == 1)

        storage.deleteHabit(id: habit.id)

        #expect(try storedCompletions().isEmpty)
    }

    @Test("deleting one habit leaves the others untouched")
    func deletingOneHabitLeavesOthersAlone() {
        let reading = makeHabit(title: "Reading", selectedDays: [1])
        let running = makeHabit(title: "Running", selectedDays: [1])
        storage.saveHabit(reading)
        storage.saveHabit(running)

        storage.deleteHabit(id: reading.id)

        #expect(storage.loadHabits(for: 1).map(\.title) == ["Running"])
    }
}
