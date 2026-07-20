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
                .padding(Spacing.x2Large)
                .glassEffect(.regular, in: .rect(cornerRadius: CornerRadius.x3Large))
        } else {
            content
                .padding(Spacing.x2Large)
                .background(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.x3Large))
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.x4Large) {
            HStack(alignment: .center, spacing: Spacing.large) {
                habitIcon

                Text(item.title)
                    .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer(minLength: Spacing.medium)

                streakLabel
            }

            VStack(alignment: .leading, spacing: Spacing.small) {
                HStack {
                    Text(L10n.Cell.Habit.journey(item.commitmentDays))
                        .font(.AppFont.rooneySansBold.size(FontSize.xLarge))
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(L10n.Cell.Habit.progressDay(completed: completedDays, total: item.commitmentDays))
                        .font(.AppFont.rooneySansBold.size(FontSize.xLarge))
                        .foregroundStyle(themeManager.appPrimary)
                }

                ProgressView(value: min(max(item.progress, 0), 1))
                    .tint(themeManager.appPrimary)
                    .scaleEffect(x: Scale.normal, y: Scale.emphasizedProgress, anchor: .center)
            }
        }
    }

    private var habitIcon: some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(Opacity.iconBackground))

            Image(systemName: item.iconName)
                .font(.system(size: FontSize.x5Large, weight: .semibold))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Size.x3Large, height: Size.x3Large)
    }

    private var streakLabel: some View {
        HStack(spacing: Spacing.x2Small) {
            Image(systemName: SystemIconName.flameFill)

            Text(L10n.Cell.Habit.streak(completedDays))
        }
        .font(.AppFont.rooneySansRegular.size(FontSize.xLarge))
        .foregroundStyle(themeManager.appPrimary)
        .lineLimit(1)
        .minimumScaleFactor(Scale.minimumText)
    }

    private var completedDays: Int {
        max(0, min(item.commitmentDays, item.commitmentDays - item.daysLeft))
    }
}


#Preview {
    let dependencies = AppDependencies()
    let id = UUID()
    let item = HabitItem(
        id: id,
        title: "test",
        daysLeft: 21,
        progress: 1,
        iconName: SystemIconName.drop,
        commitmentDays: 21
    )
    HabitListRowView(item: item)
        .environmentObject(dependencies.themeManager)
}
