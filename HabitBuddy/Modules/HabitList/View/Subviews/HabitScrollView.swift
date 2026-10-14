//
//  HabitScrollView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct HabitScrollView: View {
    let itemPerColumn: CGFloat
    let horizontalSpacing: CGFloat = .horizontalSpacing
    let height: CGFloat

    let habits: [StoredHabit]
    let selectedDate: Date

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: horizontalSpacing) {
                    ForEach(0 ..< habits.count, id: \.self) { i in
                        if i % Int(itemPerColumn) == 0 {
                            buildView(colIndex: i, geometry: geometry)
                        }
                    }
                }
                .padding(.horizontal)
            }.scrollIndicators(.hidden)
        }
    }

    // MARK: - Private

    private func buildView(colIndex: Int, geometry: GeometryProxy) -> ColumnView? {
        var colHabits = [StoredHabit]()
        for itemIndex in 0 ..< Int(itemPerColumn)
            where colIndex + itemIndex < habits.count
        {
            colHabits.append(habits[colIndex + itemIndex])
        }

        if !colHabits.isEmpty {
            return ColumnView(
                habits: colHabits,
                selectedDate: selectedDate,
                width: getWidth(geometry: geometry),
                height: height,
                verticalSpacing: .verticalSpacing
            )
        }

        return nil
    }

    private func getWidth(geometry: GeometryProxy) -> CGFloat {
        geometry.size.width * 0.65
    }
}
