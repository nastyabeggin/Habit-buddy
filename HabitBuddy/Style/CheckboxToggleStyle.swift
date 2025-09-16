//
//  CheckboxToggleStyle.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .onTapGesture {
                withAnimation(.spring(response: 0.25, dampingFraction: 1.0)) {
                    configuration.isOn.toggle()
                }
            }
    }
}
