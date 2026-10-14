//
//  IconPicker.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 12.12.2025.
//

import SwiftUI

struct IconPicker: View {
    @Binding var selectedIcon: String

    private let icons = [
        "book.fill",
        "figure.run",
        "curlybraces.square",
        "drop.fill",
        "applelogo",
        "pills.fill",
        "sun.max.fill",
        "figure.walk",
        "heart.fill",
        "leaf.fill",
        "flame.fill",
        "music.note",
        "pencil",
        "bed.double.fill",
        "fork.knife",
        "cup.and.saucer.fill",
        "dumbbell.fill",
        "bicycle",
        "brain.head.profile",
        "pawprint.fill",
        "tree.fill",
        "snowflake",
        "moon.stars.fill",
        "camera.fill",
        "house.fill"
    ]

    private let columns = [
        GridItem(.adaptive(minimum: 60), spacing: .horizontalSpacing)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .bigVerticalSpacing) {
            Text("Icon")
                .font(.customBoldSubtitle)
                .foregroundColor(Color.Font.primary)

            LazyVGrid(columns: columns, spacing: .verticalSpacing) {
                ForEach(icons, id: \.self) { icon in
                    iconButton(icon)
                }
            }
        }
    }

    // MARK: - Private

    private func iconButton(_ icon: String) -> some View {
        Button {
            selectedIcon = icon
        } label: {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(selectedIcon == icon ? Color.Font.primaryInverted : Color.Font.primary)
                .frame(width: 60, height: 60)
                .background(selectedIcon == icon ? Color.Background.accent : Color.Background.pale)
                .cornerRadius(12)
        }
    }
}

#Preview {
    IconPicker(selectedIcon: .constant("heart.fill"))
        .padding()
}
