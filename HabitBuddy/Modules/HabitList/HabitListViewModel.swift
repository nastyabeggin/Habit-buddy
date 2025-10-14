//
//  HabitListViewModel.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 20.08.2025.
//

import SwiftUI

@MainActor
final class HabitListViewModel: ObservableObject {
    // MARK: - Properties

    @Published var state: HabitListViewState
    @Published var selectedDate: Date = Calendar.current.startOfDay(for: .now)

    // MARK: - Lifecycle

    init() {
        state = .loading
        loadData()
    }

    // MARK: - Public

    // MARK: - Private

    private func loadData() {
        Task { @MainActor in
            // TODO: Add real data
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            state = .loaded(HabitListDisplayData(name: "Anastasiya", selectedDate: Date(), cards: MockStore.cards))
            selectedDate = Date()
        }
    }
}
