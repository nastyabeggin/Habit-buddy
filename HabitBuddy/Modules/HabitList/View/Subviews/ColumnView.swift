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
    let verticalSpacing: CGFloat

    var body: some View {
        VStack(spacing: verticalSpacing) {
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
    }
}

#Preview {
    ColumnView(cards: MockStore.cards, width: 200, height: 200, verticalSpacing: .verticalSpacing)
}
