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

    let cards: [CardDisplayData]

    var body: some View {
        // TODO: Add empty state
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: horizontalSpacing) {
                    ForEach(0 ..< cards.count, id: \.self) { i in
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
        var colCards = [CardDisplayData]()
        for itemIndex in 0 ..< Int(itemPerColumn)
            where colIndex + itemIndex < cards.count
        {
            colCards.append(cards[colIndex + itemIndex])
        }

        if !colCards.isEmpty {
            return ColumnView(cards: colCards, width: getWidth(geometry: geometry), height: height, verticalSpacing: .verticalSpacing)
        }

        return nil
    }

    private func getWidth(geometry: GeometryProxy) -> CGFloat {
        geometry.size.width * 0.65
    }
}

#Preview {
    HabitScrollView(itemPerColumn: 3, height: 140, cards: MockStore.cards)
}
