//
//  MockStore.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

enum MockStore {
    static let cards = [
        CardDisplayData(
            title: "Reading",
            subtitle: "Read 20 pages",
            foregroundColor: Color.Background.yellowAccent,
            icon: Image(systemName: "book.fill")
        ),
        CardDisplayData(
            title: "Running",
            subtitle: "5 km morning run",
            foregroundColor: Color.Background.greenAccent,
            icon: Image(systemName: "figure.run")
        ),
        CardDisplayData(
            title: "Coding",
            subtitle: "1 hour of Swift",
            foregroundColor: Color.Background.roseAccent,
            icon: Image(systemName: "curlybraces.square")
        ),
        CardDisplayData(
            title: "Water",
            subtitle: "Drink 2 liters",
            foregroundColor: Color.Background.roseAccent,
            icon: Image(systemName: "drop.fill")
        ),
        CardDisplayData(
            title: "Fruits",
            subtitle: "Eat 3 servings",
            foregroundColor: Color.Background.yellowAccent,
            icon: Image(systemName: "applelogo")
        ),
        CardDisplayData(
            title: "Vitamins",
            subtitle: "Take supplements",
            foregroundColor: Color.Background.roseAccent,
            icon: Image(systemName: "pills.fill")
        ),
        CardDisplayData(
            title: "Sunshine",
            subtitle: "15 min outside",
            foregroundColor: Color.Background.yellowAccent,
            icon: Image(systemName: "sun.max.fill")
        ),
        CardDisplayData(
            title: "Jogging",
            subtitle: "30 min jog",
            foregroundColor: Color.Background.greenAccent,
            icon: Image(systemName: "figure.walk")
        ),
    ]
}
