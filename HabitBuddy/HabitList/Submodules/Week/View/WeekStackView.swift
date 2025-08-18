//
//  WeekStackView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct WeekStackView: View {

    // MARK: - Properties

    @StateObject private var vm = CalendarViewModel()

    var body: some View {
        VStack(spacing: .verticalSpacing) {
            Text(vm.selectedDate, format: .dateTime.month(.wide))
                .font(.customTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            WeekView(
                selectedDate: $vm.selectedDate,
                week: vm.week,
                isHabitDone: vm.isHabitDone(on:)
            )
            .frame(height: 80)
        }
    }
}

#Preview {
    WeekStackView()
}
