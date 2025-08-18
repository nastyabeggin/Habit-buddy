//
//  DayCell.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct DayCell: View {

    // MARK: - Properties

    let date: Date
    let isSelected: Bool
    let backgroundColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isSelected ? Color.Background.accent : backgroundColor)
            VStack(spacing: 4) {
                Text(date, format: .dateTime.day())
                    .font(.primaryCompressed)

                Text(date, format: .dateTime.weekday(.abbreviated))
                    .font(.customSubtitle)
            }
            .foregroundStyle(isSelected ? Color.Font.primaryInverted : Color.Font.primary)
        }
    }
}
