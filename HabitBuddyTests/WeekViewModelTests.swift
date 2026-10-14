//
//  WeekViewModelTests.swift
//  HabitBuddyTests
//

import Foundation
import SwiftData
import Testing
@testable import HabitBuddy

/// Serialized for the same reason as the storage tests: the view model reads
/// through the `HabitStorageService` singleton.
@Suite("WeekViewModel", .serialized)
@MainActor
struct WeekViewModelTests {
    private let container: ModelContainer
    private let storage = HabitStorageService.shared

    init() throws {
        container = try makeInMemoryStore()
    }

    @Test("a day is marked done only once every habit scheduled for it is complete")
    func dayIsDoneOnlyWhenAllItsHabitsAre() {
        let wednesday = testDate(2026, 9, 23)
        let reading = makeHabit(title: "Reading", selectedDays: [wednesday.weekday])
        let running = makeHabit(title: "Running", selectedDays: [wednesday.weekday])
        storage.saveHabit(reading)
        storage.saveHabit(running)
        let viewModel = WeekViewModel()

        storage.markHabitCompleted(reading, on: wednesday)
        viewModel.update(for: wednesday)
        #expect(viewModel.isHabitDone(on: wednesday) == false)

        storage.markHabitCompleted(running, on: wednesday)
        viewModel.update(for: wednesday)
        #expect(viewModel.isHabitDone(on: wednesday) == true)
    }

    @Test("a day with no habits scheduled is never marked done")
    func dayWithoutHabitsIsNotDone() {
        let wednesday = testDate(2026, 9, 23)
        let viewModel = WeekViewModel()

        viewModel.update(for: wednesday)

        for day in wednesday.currentWeek {
            #expect(viewModel.isHabitDone(on: day) == false)
        }
    }

    /// Regression: the previous implementation was a stub that marked every day
    /// before now as done, regardless of what had actually been completed.
    @Test("past days are not marked done merely for being in the past")
    func pastDaysAreNotDoneByDefault() {
        let today = Date()
        storage.saveHabit(makeHabit(title: "Water", selectedDays: Array(1 ... 7)))
        let viewModel = WeekViewModel()

        viewModel.update(for: today)

        let pastDays = today.currentWeek.filter { $0 < today.startOfDay }
        #expect(!pastDays.isEmpty || today.startOfDay == today.currentWeek.first)
        for day in pastDays {
            #expect(viewModel.isHabitDone(on: day) == false)
        }
    }

    @Test("update covers the whole week around the given date")
    func updateCoversTheEntireWeek() {
        let wednesday = testDate(2026, 9, 23)
        storage.saveHabit(makeHabit(title: "Water", selectedDays: Array(1 ... 7)))
        let viewModel = WeekViewModel()

        viewModel.update(for: wednesday)

        #expect(viewModel.habitStatus.count == 7)
        for day in wednesday.currentWeek {
            #expect(viewModel.habitStatus[day.startOfDay] != nil)
        }
    }

    @Test("a completed day stops being done once the completion is removed")
    func unmarkingClearsTheDay() {
        let wednesday = testDate(2026, 9, 23)
        let habit = makeHabit(title: "Reading", selectedDays: [wednesday.weekday])
        storage.saveHabit(habit)
        let viewModel = WeekViewModel()
        storage.markHabitCompleted(habit, on: wednesday)
        viewModel.update(for: wednesday)
        #expect(viewModel.isHabitDone(on: wednesday) == true)

        storage.unmarkHabitCompleted(habit, on: wednesday)
        viewModel.update(for: wednesday)

        #expect(viewModel.isHabitDone(on: wednesday) == false)
    }
}
