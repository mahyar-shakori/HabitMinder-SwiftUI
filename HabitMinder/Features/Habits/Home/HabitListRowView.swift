//
//  HabitListRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct HabitListRowView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let item: HabitItem
    private let journeyLength = 21

    init(item: HabitItem) {
        self.item = item
    }

    var body: some View {
        rowBackground
    }

    @ViewBuilder
    private var rowBackground: some View {
        if #available(iOS 26.0, *) {
            content
                .padding(18)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
        } else {
            content
                .padding(18)
                .background(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .center, spacing: 14) {
                habitIcon

                Text(item.title)
                    .font(.AppFont.rooneySansBold.size(18))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer(minLength: 12)

                streakLabel
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("21-Day Journey")
                        .font(.AppFont.rooneySansBold.size(15))
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("Day \(completedDays) of \(journeyLength)")
                        .font(.AppFont.rooneySansBold.size(15))
                        .foregroundStyle(themeManager.appPrimary)
                }

                ProgressView(value: min(max(item.progress, 0), 1))
                    .tint(themeManager.appPrimary)
                    .scaleEffect(x: 1, y: 1.8, anchor: .center)
            }
        }
    }

    private var habitIcon: some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(0.45))

            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: 48, height: 48)
    }

    private var streakLabel: some View {
        Label("\(completedDays) Day Streak", systemImage: "flame.fill")
            .font(.AppFont.rooneySansRegular.size(15))
            .foregroundStyle(themeManager.appPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    private var completedDays: Int {
        max(0, min(journeyLength, journeyLength - item.daysLeft))
    }

    private var iconName: String {
        let lowercasedTitle = item.title.lowercased()

        if lowercasedTitle.contains("water") || lowercasedTitle.contains("drink") {
            return "drop"
        } else if lowercasedTitle.contains("read") || lowercasedTitle.contains("book") {
            return "book"
        } else if lowercasedTitle.contains("meditation") || lowercasedTitle.contains("mind") {
            return "figure.mind.and.body"
        } else {
            return "checkmark.circle"
        }
    }
}

#Preview {
    let id = UUID()
    let themeManager = ThemeManager()
    let item = HabitItem(
        id: id,
        title: "Drink Water",
        daysLeft: 5,
        progress: 0.7
    )
    HabitListRowView(item: item)
        .environmentObject(themeManager)
}
