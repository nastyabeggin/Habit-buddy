//
//  HabitColorPicker.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 12.12.2025.
//

import SwiftUI

struct HabitColorPicker: View {
    @Binding var selectedColor: Color

    private let colors: [Color] = [
        Color.Background.yellowAccent,
        Color.Background.greenAccent,
        Color.Background.roseAccent
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .bigVerticalSpacing) {
            Text("Color")
                .font(.customBoldSubtitle)
                .foregroundColor(Color.Font.primary)

            HStack(spacing: .doubleVerticalSpacing) {
                ForEach(colors, id: \.self) { color in
                    colorButton(color)
                }
            }
        }
    }

    // MARK: - Private

    private func colorButton(_ color: Color) -> some View {
        Button {
            selectedColor = color
        } label: {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 60, height: 60)

                if isColorSelected(color) {
                    Image(systemName: "checkmark")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Font.primaryInverted)
                }
            }
        }
    }

    private func isColorSelected(_ color: Color) -> Bool {
        color == selectedColor
    }
}

#Preview {
    HabitColorPicker(selectedColor: .constant(Color.Background.yellowAccent))
        .padding()
}
