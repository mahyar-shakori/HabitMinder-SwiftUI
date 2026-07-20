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
                .padding(Metrics.cardPadding)
                .glassEffect(.regular, in: .rect(cornerRadius: Metrics.cardCornerRadius))
        } else {
            content
                .padding(Metrics.cardPadding)
                .background(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: Metrics.cardCornerRadius))
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: Metrics.contentSpacing) {
            HStack(alignment: .center, spacing: Metrics.headerSpacing) {
                habitIcon

                Text(item.title)
                    .font(.AppFont.rooneySansBold.size(Metrics.titleFontSize))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer(minLength: Metrics.streakMinSpacing)

                streakLabel
            }

            VStack(alignment: .leading, spacing: Metrics.progressSpacing) {
                HStack {
                    Text(LocalizedStrings.Cell.Habit.journey(item.commitmentDays))
                        .font(.AppFont.rooneySansBold.size(Metrics.progressTextFontSize))
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(LocalizedStrings.Cell.Habit.progressDay(completed: completedDays, total: item.commitmentDays))
                        .font(.AppFont.rooneySansBold.size(Metrics.progressTextFontSize))
                        .foregroundStyle(themeManager.appPrimary)
                }

                ProgressView(value: min(max(item.progress, 0), 1))
                    .tint(themeManager.appPrimary)
                    .scaleEffect(x: Metrics.progressScaleX, y: Metrics.progressScaleY, anchor: .center)
            }
        }
    }

    private var habitIcon: some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(Metrics.iconBackgroundOpacity))

            Image(systemName: item.iconName)
                .font(.system(size: Metrics.iconFontSize, weight: .semibold))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Metrics.iconContainerSize, height: Metrics.iconContainerSize)
    }

    private var streakLabel: some View {
        HStack(spacing: Metrics.streakSpacing) {
            Image(systemName: AppIconName.flameFill)

            Text(LocalizedStrings.Cell.Habit.streak(completedDays))
        }
        .font(.AppFont.rooneySansRegular.size(Metrics.progressTextFontSize))
        .foregroundStyle(themeManager.appPrimary)
        .lineLimit(1)
        .minimumScaleFactor(Metrics.streakMinimumScaleFactor)
    }

    private var completedDays: Int {
        max(0, min(item.commitmentDays, item.commitmentDays - item.daysLeft))
    }
}

private enum Metrics {
    static let cardPadding: CGFloat = 18
    static let cardCornerRadius: CGFloat = 20
    static let contentSpacing: CGFloat = 22
    static let headerSpacing: CGFloat = 14
    static let progressSpacing: CGFloat = 10
    static let streakSpacing: CGFloat = 4
    static let streakMinSpacing: CGFloat = 12
    static let titleFontSize: CGFloat = 18
    static let progressTextFontSize: CGFloat = 15
    static let iconFontSize: CGFloat = 20
    static let iconContainerSize: CGFloat = 48
    static let iconBackgroundOpacity: CGFloat = 0.45
    static let progressScaleX: CGFloat = 1
    static let progressScaleY: CGFloat = 1.8
    static let streakMinimumScaleFactor: CGFloat = 0.8
}

private enum PreviewData {
    static let title = LocalizedStrings.AddHabitPage.titlePlaceholder
    static let daysLeft = 5
    static let progress = 0.7
    static let iconName = AppIconName.drop
    static let commitmentDays = 21
}

#Preview {
    let dependencies = AppDependencies()
    let id = UUID()
    let item = HabitItem(
        id: id,
        title: PreviewData.title,
        daysLeft: PreviewData.daysLeft,
        progress: PreviewData.progress,
        iconName: PreviewData.iconName,
        commitmentDays: PreviewData.commitmentDays
    )
    HabitListRowView(item: item)
        .environmentObject(dependencies.themeManager)
}
