//
//  HabitStorageService.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 12.12.2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class HabitStorageService {
    static let shared = HabitStorageService()

    private var modelContext: ModelContext?

    private init() {}

    // MARK: - Initialization

    static func initialize(with context: ModelContext) {
        shared.modelContext = context
    }

    // MARK: - Public API

    func saveHabit(_ habit: StoredHabit) {
        guard let context = modelContext else {
            print("⚠️ ModelContext not initialized")
            return
        }

        context.insert(habit)
        saveContext()
    }

    /// - Parameter weekday: Foundation weekday number (1 = Sunday ... 7 = Saturday).
    func loadHabits(for weekday: Int) -> [StoredHabit] {
        guard let context = modelContext else {
            print("⚠️ ModelContext not initialized")
            return []
        }

        let descriptor = FetchDescriptor<StoredHabit>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            let allHabits = try context.fetch(descriptor)
            return allHabits.filter { $0.selectedDays.contains(weekday) }
        } catch {
            print("❌ Failed to fetch habits: \(error)")
            return []
        }
    }

    func deleteHabit(id: UUID) {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<StoredHabit>(
            predicate: #Predicate { $0.id == id }
        )

        do {
            let habits = try context.fetch(descriptor)
            habits.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("❌ Failed to delete habit: \(error)")
        }
    }

    func updateHabit(_ habit: StoredHabit) {
        saveContext()
    }

    // MARK: - Completion Tracking

    func markHabitCompleted(_ habit: StoredHabit, on date: Date) {
        guard let context = modelContext else { return }

        let startOfDay = Calendar.current.startOfDay(for: date)

        if isHabitCompleted(habit, on: startOfDay) {
            return
        }

        let completion = HabitCompletion(for: habit, on: startOfDay)
        context.insert(completion)
        saveContext()
    }

    func unmarkHabitCompleted(_ habit: StoredHabit, on date: Date) {
        guard let context = modelContext else { return }

        let startOfDay = Calendar.current.startOfDay(for: date)
        let habitId = habit.id

        let descriptor = FetchDescriptor<HabitCompletion>(
            predicate: #Predicate<HabitCompletion> { completion in
                completion.habit?.id == habitId &&
                completion.completionDate == startOfDay
            }
        )

        do {
            let completions = try context.fetch(descriptor)
            completions.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("❌ Failed to unmark completion: \(error)")
        }
    }

    func isHabitCompleted(_ habit: StoredHabit, on date: Date) -> Bool {
        guard let context = modelContext else { return false }

        let startOfDay = Calendar.current.startOfDay(for: date)
        let habitId = habit.id

        let descriptor = FetchDescriptor<HabitCompletion>(
            predicate: #Predicate<HabitCompletion> { completion in
                completion.habit?.id == habitId &&
                completion.completionDate == startOfDay
            }
        )

        do {
            let count = try context.fetchCount(descriptor)
            return count > 0
        } catch {
            print("❌ Failed to check completion: \(error)")
            return false
        }
    }

    func getCompletionStatus(for habit: StoredHabit, dates: [Date]) -> [Date: Bool] {
        guard let context = modelContext else { return [:] }

        let habitId = habit.id
        let startDates = dates.map { Calendar.current.startOfDay(for: $0) }

        let descriptor = FetchDescriptor<HabitCompletion>(
            predicate: #Predicate<HabitCompletion> { completion in
                completion.habit?.id == habitId
            }
        )

        do {
            let completions = try context.fetch(descriptor)
            let completedDates = Set(completions.map { $0.completionDate })

            return Dictionary(uniqueKeysWithValues: startDates.map { date in
                (date, completedDates.contains(date))
            })
        } catch {
            print("❌ Failed to fetch completion status: \(error)")
            return Dictionary(uniqueKeysWithValues: dates.map { ($0, false) })
        }
    }

    // MARK: - Private Helpers

    private func saveContext() {
        guard let context = modelContext else { return }

        do {
            try context.save()
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }
}
