//
//  ColumnView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct ColumnView: View {

    let cards: [CardDisplayData]
    let width: CGFloat
    let height: CGFloat
    let horizontalSpacing: CGFloat

    var body: some View {
        VStack(spacing: horizontalSpacing) {
            ForEach(cards) { card in
                CardView(
                    title: card.title,
                    subtitle: card.subtitle,
                    foregroundColor: card.foregroundColor,
                    icon: card.icon
                )
                    .frame(width: width, height: height)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 8)
    }
}

#Preview {
    ColumnView(cards: MockStore.cards, width: 200, height: 200, horizontalSpacing: 20)
}
