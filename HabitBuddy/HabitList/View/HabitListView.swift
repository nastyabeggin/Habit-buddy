//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Anastasiya Beginina on 01.07.2025.
//

import SwiftUI

struct HabitListView: View {

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: .verticalSpacing) {
                    HelloHeaderView(name: "Stacy", hasNotifications: false)
                    WeekStackView()
                        .modifier(Shimmer())

                    HabitScrollView(itemPerColumn: 3, height: geometry.size.height / CGFloat(6))
                }
                .redacted(reason: .placeholder)
            }
        }
    }
}

#Preview {
    HabitListView()
}
