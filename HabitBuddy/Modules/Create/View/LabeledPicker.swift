//
//  LabeledPicker.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 16.10.2025.
//

import SwiftUI

struct WeekdayPicker: View {
    @Binding var selection: Set<Int>

    private let selectedFill: Color = .accentColor
    private let unselectedFill: Color = .TextField.border
    private let textSelected: Color = .white
    private let textUnselected: Color = .primary

    private let size: CGFloat = 44
    private let spacing: CGFloat = 10
    private let calendar: Calendar = .current

    private var orderedSymbols: [String] {
        let syms = calendar.shortWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return Array(syms[first...] + syms[..<first])
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Repeat on")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.customBoldSubtitle)
            HStack(spacing: spacing) {
                ForEach(orderedSymbols.indices, id: \.self) { idx in
                    let isOn = selection.contains(idx)
                    Button {
                        toggle(idx)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(isOn ? selectedFill : unselectedFill)
                            Text(orderedSymbols[idx].prefix(2).uppercased())
                                .font(Font.customBoldSubtitle)
                                .foregroundStyle(isOn ? textSelected : textUnselected)
                        }
                        .frame(width: size, height: size)
                        .contentShape(Circle())
                        .accessibilityLabel(dayAccessibilityLabel(at: idx))
                        .accessibilityValue(isOn ? "selected" : "not selected")
                    }
                    .buttonStyle(.plain)
                }
            }
            HStack(alignment: .lastTextBaseline) {
                Button {
                    withAnimation {
                        if selection.count == 7 {
                            selection.removeAll()
                        } else {
                            selection = Set(0 ..< 7)
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: selection.count == 7 ? "checkmark.circle.fill" : "circle")
                        Text("every day")
                    }
                    .font(Font.customSubtitle)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.TextField.border, lineWidth: 2)
                    )
                }
                .buttonStyle(.plain)

                if !selection.isEmpty, selection.count < 7 {
                    Button("clear") {
                        withAnimation {
                            selection.removeAll()
                        }
                    }
                        .font(Font.customSubtitle)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func toggle(_ idx: Int) {
        if selection.contains(idx) {
            selection.remove(idx)
        } else {
            selection.insert(idx)
        }
    }

    private func dayAccessibilityLabel(at idx: Int) -> String {
        let long = calendar.weekdaySymbols
        let first = calendar.firstWeekday - 1
        let orderedLong = Array(long[first...] + long[..<first])
        return idx < orderedLong.count ? orderedLong[idx] : orderedSymbols[idx]
    }
}

#Preview {
    WeekdayPicker(selection: .constant([0, 1, 2]))
}
