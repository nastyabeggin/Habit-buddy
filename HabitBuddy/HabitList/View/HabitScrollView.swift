//
//  HabitScrollView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct CardDisplayData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let foregroundColor: Color
    let icon: Image
}

struct HabitScrollView: View {

    let itemPerColumn: CGFloat
    let horizontalSpacing: CGFloat = 16
    let height: CGFloat
    
    let cards: [CardDisplayData] = MockStore.cards

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(0 ..< cards.count) { i in
                        if i % Int(itemPerColumn) == 0 {
                            buildView(colIndex: i, geometry: geometry)
                        }
                    }
                }
            }.scrollIndicators(.hidden)
        }
    }

    // MARK: - Private

    private func buildView(colIndex: Int, geometry: GeometryProxy) -> ColumnView? {
        var colCards = [CardDisplayData]()
        for itemIndex in 0 ..< Int(itemPerColumn) {
            if colIndex + itemIndex < cards.count {
                colCards.append(cards[colIndex + itemIndex])
            }
        }

        if !colCards.isEmpty {
            return ColumnView(cards: colCards, width: getWidth(geometry: geometry), height: height, horizontalSpacing: horizontalSpacing)
        }

        return nil
    }
    
    private func getWidth(geometry: GeometryProxy) -> CGFloat {
        geometry.size.width * 0.65
    }
}

#Preview {
    HabitScrollView(itemPerColumn: 3, height: 140)
}
