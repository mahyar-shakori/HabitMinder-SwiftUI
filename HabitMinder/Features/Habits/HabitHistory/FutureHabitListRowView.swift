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
        VStack(spacing: Spacing.large) {
            HStack(alignment: .center, spacing: Spacing.large) {
                habitIcon

                Text(item.title)
                    .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                dateBadge
            }

            AppButton(L10n.FutureHabitsPage.startNowButton, variant: .compactPrimary) {
                onStart()
            }
        }
        .padding(Spacing.xLarge)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
    }

    private var habitIcon: some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(Opacity.iconBackground))

            Image(systemName: item.iconName)
                .font(.system(size: FontSize.x4Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Size.x3Large, height: Size.x3Large)
    }

    private var dateBadge: some View {
        Text(dateText)
            .font(.AppFont.rooneySansBold.size(FontSize.xSmall))
            .textCase(.uppercase)
            .foregroundStyle(themeManager.appPrimary)
            .padding(.horizontal, Spacing.xSmall + LineWidth.thin)
            .padding(.vertical, Spacing.x2Small + LineWidth.thin)
            .background(themeManager.appSecondary.opacity(Opacity.iconBackground))
            .clipShape(Capsule())
    }

    private var dateText: String {
        let daysUntilStart = Calendar.current.dateComponents([.day], from: .now, to: item.dateCreate).day ?? 0

        if daysUntilStart > LayoutCount.zero, daysUntilStart <= LayoutCount.nearFutureDayLimit {
            return L10n.FutureHabitsPage.startInDays(daysUntilStart)
        }

        return item.dateCreate.formatted(.dateTime.month(.abbreviated).day())
    }

}


#Preview {
    let dependencies = AppDependencies()
    let item = FutureHabitItem(
        id: UUID(),
        title: "test",
        dateCreate: .now.addingTimeInterval(10),
        iconName: SystemIconName.book,
        commitmentDays: 21
    )

    FutureHabitListRowView(item: item)
        .environmentObject(dependencies.themeManager)
        .padding()
        .background(.appGray)
}
