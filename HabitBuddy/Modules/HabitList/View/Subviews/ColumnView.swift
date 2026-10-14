//
//  ColumnView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct ColumnView: View {
    let habits: [StoredHabit]
    let selectedDate: Date
    let width: CGFloat
    let height: CGFloat
    let verticalSpacing: CGFloat

    var body: some View {
        VStack(spacing: verticalSpacing) {
            ForEach(habits, id: \.id) { habit in
                CardView(
                    habit: habit,
                    selectedDate: selectedDate,
                    foregroundColor: Color(hex: habit.colorHex),
                    icon: Image(systemName: habit.iconName)
                )
                .frame(width: width, height: height)
            }
        }
        .padding(.vertical)
    }
}
