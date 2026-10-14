//
//  HabitBuddyApp.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftData
import SwiftUI

@main
struct HabitBuddyApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                StoredHabit.self,
                HabitCompletion.self
            ])

            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )

            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            HabitStorageService.initialize(with: modelContainer.mainContext)

        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
