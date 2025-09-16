//
//  WeekViewModel.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

@MainActor
class WeekViewModel: ObservableObject {

    // MARK: - Properties
    /// stub для отметок «выполнено/нет»
    /// в реальности заполнится при запросе на бэкенд
    @Published var habitStatus: [Date: Bool] = [:]

    // MARK: - Public

    func isHabitDone(on date: Date) -> Bool {
        habitStatus[date.startOfDay] ?? false
    }

    func update(for selectedDate: Date) {
        let week = selectedDate.currentWeek
        // TODO: заменить на данные с бэка
        habitStatus = Dictionary(uniqueKeysWithValues: week.map { ($0.startOfDay, $0 < Date()) })
    }
}
