//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct HabitListView: View {
    @State var viewModel = HabitListViewModel()
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
                .padding(.bottom, 30)
                .ignoresSafeArea(.keyboard)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
        .sheet(isPresented: $showCreate) {
            viewModel.loadData()
        } content: {
            CreateHabitView()
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
                    habits: [],
                    selectedDate: viewModel.selectedDate
                )
            }
            .redacted(reason: .placeholder)
        case .loaded:
            VStack(spacing: .verticalSpacing) {
                HelloHeaderView(name: "Anastasiya", hasNotifications: false)
                WeekStackView(selectedDate: $viewModel.selectedDate)
                HabitScrollView(
                    itemPerColumn: 3,
                    height: geometry.size.height / CGFloat(6),
                    habits: viewModel.habits,
                    selectedDate: viewModel.selectedDate
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
