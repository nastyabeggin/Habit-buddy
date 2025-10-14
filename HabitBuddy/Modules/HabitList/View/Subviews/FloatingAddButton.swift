//
//  FloatingAddButton.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 17.09.2025.
//

import SwiftUI

struct FloatingAddButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(backgroundShape)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
        }
        .accessibilityLabel("добавить")
    }

    @ViewBuilder
    private var backgroundShape: some View {
        if #available(iOS 26.0, *) {
            Circle().glassEffect(.regular.tint(.accent).interactive())
        } else {
            Circle().fill(Color.accentColor)
        }
    }
}
