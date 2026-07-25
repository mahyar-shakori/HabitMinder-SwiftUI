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
        content
            .padding(Spacing.x2Large)
            .liquidGlass(
                in: .rect(cornerRadius: CornerRadius.medium),
                interactive: false,
                fallback: .appWhite
            )
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.x4Large) {
            habitSummaryRow
            habitProgressSection
        }
    }

    private var habitSummaryRow: some View {
        HStack(alignment: .center, spacing: Spacing.large) {
            habitIcon
            habitTitle

            Spacer(minLength: Spacing.medium)

            streakLabel
        }
    }

    private var habitTitle: some View {
        Text(item.title)
            .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
            .foregroundStyle(.primary)
            .lineLimit(1)
    }

    private var habitProgressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            progressHeader
            progressBar
        }
    }

    private var progressHeader: some View {
        HStack {
            Text(L10n.Cell.journey(item.commitmentDays))
                .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)

            Spacer()

            Text(L10n.Cell.progressDay(completed: completedDays, total: item.commitmentDays))
                .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                .foregroundStyle(.secondary)
        }
    }

    private var progressBar: some View {
        ProgressView(value: min(max(item.progress, 0), 1))
            .tint(themeManager.appPrimary)
            .scaleEffect(x: Scale.normal, y: Scale.emphasizedProgress, anchor: .center)
    }

    private var habitIcon: some View {
        Image(systemName: item.iconName)
            .font(.system(size: FontSize.x5Large, weight: .medium))
            .foregroundStyle(.secondary)
            .frame(width: Size.x3Large, height: Size.x3Large)
            .background(.gray.opacity(Opacity.subtleBorder))
            .clipShape(Circle())
    }

    private var streakLabel: some View {
        HStack(spacing: Spacing.x2Small) {
            Image(systemName: SystemIconName.flameFill)

            Text(L10n.Cell.streak(completedDays))
        }
        .font(.AppFont.rooneySansRegular.size(FontSize.medium))
        .foregroundStyle(.secondary)
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
