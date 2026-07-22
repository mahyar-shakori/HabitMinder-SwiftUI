//
//  FutureHabitItem.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import Foundation

struct FutureHabitItem: Identifiable {
    let id: UUID
    let title: String
    let dateCreate: Date
    let iconName: String
    let commitmentDays: Int

    var dateText: String {
        let daysUntilStart = Calendar.current.dateComponents([.day], from: .now, to: dateCreate).day ?? 0

        if daysUntilStart > LayoutCount.zero, daysUntilStart <= LayoutCount.nearFutureDayLimit {
            return L10n.HabitHistoryPage.startInDays(daysUntilStart)
        }

        return dateCreate.formatted(.dateTime.month(.abbreviated).day())
    }
}
