//
//  WeekStackView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct WeekStackView: View {
    
    // MARK: - Properties
    
    @Binding var selectedDate: Date
    @StateObject private var vm = WeekViewModel()
    
    var body: some View {
        VStack(spacing: .verticalSpacing) {
            Text(selectedDate, format: .dateTime.month(.wide))
                .font(.customTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            WeekView(
                selectedDate: $selectedDate,
                week: Week(dates: selectedDate.currentWeek),
                isHabitDone: vm.isHabitDone(on:)
            )
            .frame(height: 80)
        }
        .onAppear { vm.update(for: selectedDate) }
        .onChange(of: selectedDate) { _, new in vm.update(for: new) }
    }
}

#Preview {
    WeekStackView(selectedDate: .constant(Date()))
}
