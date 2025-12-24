//
//  LabeledInputField.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 16.10.2025.
//
import SwiftUI

struct LabeledInputField<F: Hashable>: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let focusedField: FocusState<F?>.Binding
    let id: F

    private var isFocused: Bool { focusedField.wrappedValue == id }

    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat.verticalSpacing) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.customBoldSubtitle)

            TextField(placeholder, text: $text)
                .submitLabel(.next)
                .padding(CGFloat.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.accent : Color.TextField.border, lineWidth: 2)
                )
                .font(.customSubtitle)
                .focused(focusedField, equals: id)
        }
    }
}
