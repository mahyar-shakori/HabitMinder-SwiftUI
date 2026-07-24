//
//  HabitHistoryListRowView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 16/04/2025.
//

import SwiftUI

struct HabitHistoryListRowView: View {
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
            
            habitSummaryRow
            startOverButton
        }
        .padding(Spacing.xLarge)
        .liquidGlass(
            in: .rect(cornerRadius: CornerRadius.medium),
            interactive: false,
            fallback: .appWhite
        )
    }
    
    private var habitSummaryRow: some View {
        HStack(alignment: .center, spacing: Spacing.large) {
            habitIcon

            Text(item.title)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            dateBadge
        }
    }
    
    private var startOverButton: some View {
        AppPrimaryButton(
            title: L10n.HabitHistoryPage.startNowButton,
            size: .regular,
            action: onStart
        )
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
        Text(item.dateText)
            .font(.AppFont.rooneySansBold.size(FontSize.xSmall))
            .textCase(.uppercase)
            .foregroundStyle(themeManager.appPrimary)
            .padding(.horizontal, Spacing.xSmall + LineWidth.thin)
            .padding(.vertical, Spacing.x2Small + LineWidth.thin)
            .background(themeManager.appSecondary.opacity(Opacity.iconBackground))
            .clipShape(Capsule())
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

    HabitHistoryListRowView(item: item)
        .environmentObject(dependencies.themeManager)
        .padding()
        .background(.appGray)
}
