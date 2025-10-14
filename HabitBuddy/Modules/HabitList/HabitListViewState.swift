//
//  HabitListViewState.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 20.08.2025.
//

import SwiftUI

struct CardDisplayData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let foregroundColor: Color
    let icon: Image
}

struct HabitListDisplayData {
    var name: String
    var selectedDate: Date
    var cards: [CardDisplayData]

    static let empty = HabitListDisplayData(name: "", selectedDate: Date(), cards: [])
}

enum HabitListViewState: Equatable {
    static func == (lhs: HabitListViewState, rhs: HabitListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            true
        case let (.error(lhsError), .error(rhsError)):
            lhsError == rhsError
        default:
            false
        }
    }

    case loading
    case loaded(HabitListDisplayData)
    case error(String)
}
