//
//  CreateHabitViewState.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 15.10.2025.
//

import SwiftUI

struct CreateHabitViewState {
    struct TextField {
        let name: String
        let description: String
        var value: String
    }

    let navigationTitle: String
    var habit: TextField
    var description: TextField
    var days: Set<Int>
    var iconName: String
    var foregroundColor: Color

    @MainActor
    static var defaultState: Self = CreateHabitViewState(
        navigationTitle: "Let's start a new habit",
        habit: TextField(name: "Name", description: "Type habit name", value: ""),
        description: TextField(name: "Description", description: "Describe a habit", value: ""),
        days: [],
        iconName: "heart.fill",
        foregroundColor: Color.Background.yellowAccent
    )
}
