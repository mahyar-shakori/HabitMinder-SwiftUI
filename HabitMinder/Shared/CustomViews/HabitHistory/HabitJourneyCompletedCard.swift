//
//  HabitJourneyCompletedCard.swift
//  HabitMinder
//
//  Created by Mahyar on 22/07/2026.
//

import SwiftUI

struct HabitJourneyCompletedCard: View {
    let item: CompletedHabitItem

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: Spacing.large) {
            cardHeader
            progressView
            statusRow
        }
        .padding(Spacing.xLarge)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.x2Large))
    }

    private var cardHeader: some View {
        HStack(alignment: .top, spacing: Spacing.large) {
            habitIcon
            habitInfo

            Spacer()

            medalIcon
        }
    }

    private var habitIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(themeManager.appSecondary.opacity(Opacity.completedIconBackground))

            Image(systemName: item.iconName)
                .font(.system(size: FontSize.x4Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Size.x3Large, height: Size.x3Large)
    }

    private var habitInfo: some View {
        VStack(alignment: .leading, spacing: Spacing.x2Small) {
            Text(item.title)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                .foregroundStyle(.primary)

            Text(L10n.HabitHistoryPage.finishedDate(item.completedAt.formatted(.dateTime.month(.abbreviated).day().year())))
                .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                .foregroundStyle(.secondary)
        }
    }

    private var medalIcon: some View {
        Image(systemName: SystemIconName.medal)
            .font(.system(size: FontSize.x2Large, weight: .semibold))
            .foregroundStyle(themeManager.appPrimary)
            .padding(Spacing.xSmall)
            .background(.appGray)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
    }

    private var progressView: some View {
        ProgressView(value: Scale.normal)
            .tint(themeManager.appPrimary)
            .scaleEffect(x: Scale.normal, y: Scale.progress, anchor: .center)
    }

    private var statusRow: some View {
        HStack {
            Text(L10n.HabitHistoryPage.streakDays(item.commitmentDays))
            Spacer()
            Text(L10n.HabitHistoryPage.completedStatus)
        }
        .font(.AppFont.rooneySansRegular.size(FontSize.medium))
        .foregroundStyle(.secondary)
    }
}
