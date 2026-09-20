//
//  CardView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct CardView: View {
    let habit: StoredHabit
    let selectedDate: Date
    let foregroundColor: Color
    let icon: Image

    @State private var isCompleted = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(isCompleted ? .Background.pale : foregroundColor)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        icon
                            .foregroundColor(isCompleted ? Color.Font.onPale : Color.Font.primaryOnLight)
                            .font(.system(size: 30))
                        Spacer()
                        Toggle("", isOn: completionBinding)
                            .toggleStyle(CheckboxToggleStyle())
                            .foregroundStyle(Color.Font.primaryOnLight)
                            .labelsHidden()
                    }
                    Spacer()
                    Text(habit.title)
                        .font(.customTitle)
                        .foregroundStyle(isCompleted ? Color.Font.onPale : Color.Font.primaryOnLight)
                    Text(habit.subtitle)
                        .font(.customSubtitle)
                        .foregroundStyle(isCompleted ? Color.Font.onPale : Color.Font.primaryOnLight)
                }
                .padding()
                Spacer()
            }
        }
        .onTapGesture {
            toggleCompletion()
        }
        .onAppear {
            loadCompletionStatus()
        }
        .onChange(of: selectedDate) { _, _ in
            loadCompletionStatus()
        }
    }

    private var completionBinding: Binding<Bool> {
        Binding(
            get: { isCompleted },
            set: { _ in toggleCompletion() }
        )
    }

    private func loadCompletionStatus() {
        isCompleted = HabitStorageService.shared.isHabitCompleted(habit, on: selectedDate)
    }

    private func toggleCompletion() {
        withAnimation(.spring(response: 0.25, dampingFraction: 1.0)) {
            if isCompleted {
                HabitStorageService.shared.unmarkHabitCompleted(habit, on: selectedDate)
            } else {
                HabitStorageService.shared.markHabitCompleted(habit, on: selectedDate)
            }
            isCompleted.toggle()
        }
    }
}
