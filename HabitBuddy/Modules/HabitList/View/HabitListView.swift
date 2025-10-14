//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct HabitListView: View {
    @ObservedObject var viewModel = HabitListViewModel()
    @State private var showCreate = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ScrollView {
                    content(geometry: geo)
                }

                FloatingAddButton {
                    showCreate = true
                }
                .padding(.bottom, 20)
                .ignoresSafeArea(.keyboard)
            }
        }
        .sheet(isPresented: $showCreate) {
            EmptyView()
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func content(geometry: GeometryProxy) -> some View {
        switch viewModel.state {
        case .loading:
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
        case let .loaded(habitListDisplayData):
            VStack(spacing: .verticalSpacing) {
                HelloHeaderView(name: habitListDisplayData.name, hasNotifications: false)
                WeekStackView(selectedDate: $viewModel.selectedDate)
                HabitScrollView(
                    itemPerColumn: 3,
                    height: geometry.size.height / CGFloat(6),
                    cards: habitListDisplayData.cards
                )
            }
        case .error:
            VStack { Spacer(); Text("Что-то пошло не так"); Spacer() }
            // TODO: Add error state
        }
    }
}

#Preview {
    HabitListView()
}
