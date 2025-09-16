//
//  ButtonCustomStyle.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct ButtonCustomStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.Font.primary)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 1.0), value: configuration.isPressed)
    }
}
