//
//  CreateHabitView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 17.09.2025.
//

import SwiftUI

struct CreateHabitView: View {
    @State var viewModel = CreateHabitViewModel()
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss

    enum Field: Hashable {
        case habit
        case description
    }

    private enum Constants {
        /// The sheet's presentation animation steals focus if it is set straight
        /// away, so wait for it to settle first.
        static let initialFocusDelay: Duration = .milliseconds(350)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: CGFloat.doubleVerticalSpacing) {
                    LabeledInputField(
                        title: viewModel.state.habit.name,
                        placeholder: viewModel.state.habit.description,
                        text: $viewModel.state.habit.value,
                        focusedField: $focusedField,
                        id: .habit
                    )

                    LabeledInputField(
                        title: viewModel.state.description.name,
                        placeholder: viewModel.state.description.description,
                        text: $viewModel.state.description.value,
                        focusedField: $focusedField,
                        id: .description
                    )

                    HabitColorPicker(selectedColor: $viewModel.state.foregroundColor)

                    IconPicker(selectedIcon: $viewModel.state.iconName)

                    WeekdayPicker(selection: $viewModel.state.days)
                }
                .padding()
            }
            .task {
                try? await Task.sleep(for: Constants.initialFocusDelay)
                focusedField = .habit
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.state.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }

    // MARK: - Private

    private func saveHabit() {
        viewModel.saveHabit()
        dismiss()
    }
}

#Preview {
    CreateHabitView()
}
