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
