//
//  WeekScrollView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct WeekView: View {
    // MARK: - Properties

    @Binding var selectedDate: Date

    let week: Week
    let isHabitDone: (Date) -> Bool

    private let cellWidth: CGFloat = 60

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: .horizontalSpacing) {
                ForEach(week.dates, id: \.self) { date in
                    let done = isHabitDone(date)
                    DayCell(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        backgroundColor: done ? Color.Background.greenAccent : Color.Background.pale
                    )
                    .frame(width: cellWidth)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 1.0)) { selectedDate = date }
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .animation(.default, value: week)
    }
}
