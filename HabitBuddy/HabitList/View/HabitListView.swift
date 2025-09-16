//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct HabitListView: View {
    @ObservedObject var viewModel = HabitListViewModel()

    var body: some View {
        switch viewModel.state {
        case .loading:
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: .verticalSpacing) {
                        HelloHeaderView(name: "Placeholder", hasNotifications: false)
                        WeekStackView(selectedDate: $viewModel.selectedDate)
                        HabitScrollView(
                            itemPerColumn: 3,
                            height: geometry.size.height / CGFloat(6),
                            cards: MockStore.cards
                        )
                    }
                    .redacted(reason: .placeholder)
                }
            }
        case let .loaded(habitListDisplayData):
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: .verticalSpacing) {
                        HelloHeaderView(name: habitListDisplayData.name, hasNotifications: false)
                        WeekStackView(selectedDate: $viewModel.selectedDate)
                        HabitScrollView(
                            itemPerColumn: 3,
                            height: geometry.size.height / CGFloat(6),
                            cards: habitListDisplayData.cards
                        )
                    }
                }
            }
        case .error:
            Text("")
            // TODO: Add error state
        }
    }
}

#Preview {
    HabitListView()
}
