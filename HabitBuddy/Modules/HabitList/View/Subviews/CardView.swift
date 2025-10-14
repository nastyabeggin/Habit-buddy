//
//  CardView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 27.06.2025.
//

import SwiftUI

struct CardView: View {
    let title: String
    let subtitle: String
    let foregroundColor: Color
    let icon: Image

    @State private var isToggleOn = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(isToggleOn ? .Background.pale : foregroundColor)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        icon
                            .foregroundColor(isToggleOn ? Color.Font.onPale : Color.Font.primaryOnLight)
                            .font(.system(size: 30))
                        Spacer()
                        Toggle("", isOn: $isToggleOn)
                            .toggleStyle(CheckboxToggleStyle())
                            .foregroundStyle(Color.Font.primaryOnLight)
                            .labelsHidden()
                    }
                    Spacer()
                    Text(title)
                        .font(.customTitle)
                        .foregroundStyle(isToggleOn ? Color.Font.onPale : Color.Font.primaryOnLight)
                    Text(subtitle)
                        .font(.customSubtitle)
                        .foregroundStyle(isToggleOn ? Color.Font.onPale : Color.Font.primaryOnLight)
                }
                .padding()
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.25, dampingFraction: 1.0)) {
                isToggleOn.toggle()
            }
        }
    }
}

#Preview {
    CardView(
        title: "Test",
        subtitle: "Subtitle",
        foregroundColor: Color.Background.greenAccent,
        icon: Image(systemName: "book.fill")
    )
}
