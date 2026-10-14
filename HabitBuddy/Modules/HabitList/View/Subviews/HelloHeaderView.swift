//
//  HelloHeaderView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct HelloHeaderView: View {
    // MARK: - Properties

    let name: String
    let hasNotifications: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            helloHeaderText()
            Spacer()
            buttons()
        }.padding()
    }

    // MARK: - Private

    private func helloHeaderText() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Good \(timeString()),")
                .font(.customSubheader)
            Text(name)
                .font(.customHeader)
        }
    }

    private func buttons() -> some View {
        HStack(spacing: 15) {
            Button(action: {}) {
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 24, height: 24)
            .buttonStyle(ButtonCustomStyle())
            Button(action: {}) {
                Image(systemName: hasNotifications ? "bell.badge" : "bell")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(hasNotifications ? Color.Background.yellowAccent : Color.Font.primary, Color.Font.primary)
            }
            .frame(width: 24, height: 24)
            .buttonStyle(ButtonCustomStyle())
        }
    }

    private func timeString() -> String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 0 ..< 12:
            "morning"
        case 12 ..< 18:
            "afternoon"
        default:
            "evening"
        }
    }
}

#Preview {
    HelloHeaderView(name: "Stacy", hasNotifications: true)
}
