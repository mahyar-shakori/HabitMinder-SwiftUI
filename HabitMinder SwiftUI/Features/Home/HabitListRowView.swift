//
//  HabitListRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct HabitListRowView: View {
    let item: HabitItem
    
    var body: some View {
        HStack(spacing: 16) {
            ProgressCircleView(progress: item.progress)
            
            Text(item.title)
                .font(.AppFont.rooneySansBold.size(18))
            
            Spacer()
            
            Text("\(item.daysLeft)" + LocalizedStrings.Cell.Habit.daysLeft)
                .font(.AppFont.rooneySansRegular.size(14))
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}
