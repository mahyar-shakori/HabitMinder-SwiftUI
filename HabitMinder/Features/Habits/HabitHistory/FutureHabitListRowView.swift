//
//  FutureHabitListRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct FutureHabitListRowView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let item: FutureHabitItem
    let onStart: () -> Void

    init(
        item: FutureHabitItem,
        onStart: @escaping () -> Void = {}
    ) {
        self.item = item
        self.onStart = onStart
    }

    var body: some View {
        VStack(spacing: Metrics.contentSpacing) {
            HStack(alignment: .center, spacing: Metrics.contentSpacing) {
                habitIcon

                Text(item.title)
                    .font(.AppFont.rooneySansBold.size(Metrics.titleFontSize))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                dateBadge
            }

            AppButton(LocalizedStrings.FutureHabitsPage.startNowButton, variant: .compactPrimary) {
                onStart()
            }
        }
        .padding(Metrics.cardPadding)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.cardCornerRadius))
    }

    private var habitIcon: some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(Metrics.iconBackgroundOpacity))

            Image(systemName: item.iconName)
                .font(.system(size: Metrics.iconFontSize, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Metrics.iconContainerSize, height: Metrics.iconContainerSize)
    }

    private var dateBadge: some View {
        Text(dateText)
            .font(.AppFont.rooneySansBold.size(Metrics.badgeFontSize))
            .textCase(.uppercase)
            .foregroundStyle(themeManager.appPrimary)
            .padding(.horizontal, Metrics.badgeHorizontalPadding)
            .padding(.vertical, Metrics.badgeVerticalPadding)
            .background(themeManager.appSecondary.opacity(0.45))
            .clipShape(Capsule())
    }

    private var dateText: String {
        let daysUntilStart = Calendar.current.dateComponents([.day], from: .now, to: item.dateCreate).day ?? 0

        if daysUntilStart > Metrics.todayOffset, daysUntilStart <= Metrics.nearFutureDayLimit {
            return LocalizedStrings.FutureHabitsPage.startInDays(daysUntilStart)
        }

        return item.dateCreate.formatted(.dateTime.month(.abbreviated).day())
    }

}

private enum Metrics {
    static let contentSpacing: CGFloat = 14
    static let cardPadding: CGFloat = 16
    static let cardCornerRadius: CGFloat = 14
    static let titleFontSize: CGFloat = 17
    static let iconFontSize: CGFloat = 18
    static let iconContainerSize: CGFloat = 48
    static let iconBackgroundOpacity: CGFloat = 0.45
    static let badgeFontSize: CGFloat = 11
    static let badgeHorizontalPadding: CGFloat = 9
    static let badgeVerticalPadding: CGFloat = 5
    static let todayOffset = 0
    static let nearFutureDayLimit = 7
}

private enum PreviewData {
    static let title = LocalizedStrings.AddHabitPage.titlePlaceholder
    static let startDelay: TimeInterval = 60 * 60 * 24 * 3
    static let iconName = AppIconName.book
    static let commitmentDays = 21
}

#Preview {
    let dependencies = AppDependencies()
    let item = FutureHabitItem(
        id: UUID(),
        title: PreviewData.title,
        dateCreate: .now.addingTimeInterval(PreviewData.startDelay),
        iconName: PreviewData.iconName,
        commitmentDays: PreviewData.commitmentDays
    )

    FutureHabitListRowView(item: item)
        .environmentObject(dependencies.themeManager)
        .padding()
        .background(.appGray)
}
