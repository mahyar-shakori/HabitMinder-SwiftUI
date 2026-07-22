//
//  NotificationSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    private var viewModel: NotificationSettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: NotificationSettingsViewModel) {
        self.viewModel = viewModel
    }

    private var allowNotificationsBinding: Binding<Bool> {
        Binding {
            viewModel.allowNotifications
        } set: { isOn in
            viewModel.setAllowNotifications(isOn)
        }
    }

    private var dailyRemindersBinding: Binding<Bool> {
        Binding {
            viewModel.dailyRemindersToggleValue
        } set: { isOn in
            viewModel.setDailyReminders(isOn)
        }
    }

    private var journeyCompletionBinding: Binding<Bool> {
        Binding {
            viewModel.journeyCompletionToggleValue
        } set: { isOn in
            viewModel.setJourneyCompletionNotifications(isOn)
        }
    }

    private var dailyQuotesBinding: Binding<Bool> {
        Binding {
            viewModel.dailyQuotes
        } set: { isOn in
            viewModel.setDailyQuotes(isOn)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.x5Large) {
                pageIntro
                generalSection
                ritualRemindersSection
                motivationSection
            }
            .padding(.horizontal, Spacing.x4Large)
            .padding(.top, Spacing.x5Large)
            .padding(.bottom, Spacing.x5Large)
        }
        .scrollIndicators(.hidden)
        .background(.appGray)
        .navigationTitle(L10n.SettingPage.notifications)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var pageIntro: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(L10n.NotificationSettings.introTitle)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(L10n.NotificationSettings.introDescription)
                .font(.AppFont.rooneySansRegular.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, Spacing.xSmall)
    }

    private var generalSection: some View {
        settingsSection(title: L10n.NotificationSettings.general) {
            toggleRow(
                iconName: SystemIconName.bell,
                title: L10n.NotificationSettings.allowNotifications,
                isOn: allowNotificationsBinding
            )

            Text(L10n.NotificationSettings.allowNotificationsDescription)
                .sectionDescriptionStyle()
        }
    }

    private var ritualRemindersSection: some View {
        settingsSection(title: L10n.NotificationSettings.ritualReminders) {
            VStack(spacing: Spacing.none) {
                toggleRow(
                    iconName: SystemIconName.calendar,
                    title: L10n.NotificationSettings.dailyReminders,
                    isOn: dailyRemindersBinding,
                    isEnabled: viewModel.allowNotifications,
                    clipsBackground: false
                )

                Divider()
                    .padding(.leading, Size.x3Large + Spacing.x3Large)

                toggleRow(
                    iconName: SystemIconName.sparkles,
                    title: L10n.NotificationSettings.journeyCompletion,
                    isOn: journeyCompletionBinding,
                    isEnabled: viewModel.allowNotifications,
                    clipsBackground: false
                )
            }
            .background(.appWhite)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))

            Text(L10n.NotificationSettings.journeyCompletionDescription)
                .sectionDescriptionStyle()
        }
    }

    private var motivationSection: some View {
        settingsSection(title: L10n.NotificationSettings.motivation) {
            toggleRow(
                iconName: SystemIconName.quoteBubble,
                title: L10n.NotificationSettings.dailyQuotes,
                isOn: dailyQuotesBinding
            )

            Text(L10n.NotificationSettings.dailyQuotesDescription)
                .sectionDescriptionStyle()
        }
    }

    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(title.uppercased())
                .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .padding(.horizontal, Spacing.large)

            content()
        }
    }

    private func toggleRow(
        iconName: String,
        title: String,
        isOn: Binding<Bool>,
        isEnabled: Bool = true,
        clipsBackground: Bool = true
    ) -> some View {
        HStack(spacing: Spacing.large) {
            rowIcon(iconName, isEnabled: isEnabled)

            Text(title)
                .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                .foregroundStyle(.primary)

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(themeManager.appPrimary)
                .disabled(isEnabled.not)
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: clipsBackground ? CornerRadius.medium : 0))
        .opacity(isEnabled ? 1 : Opacity.secondaryTint)
    }

    private func rowIcon(_ iconName: String, isEnabled: Bool) -> some View {
        ZStack {
            Circle()
                .fill(isEnabled ? themeManager.appSecondary.opacity(Opacity.badgeBackground) : .gray.opacity(Opacity.subtle))

            Image(systemName: iconName)
                .font(.system(size: FontSize.x5Large, weight: .medium))
                .foregroundStyle(isEnabled ? themeManager.appPrimary : .secondary)
        }
        .frame(width: Size.x2Large, height: Size.x2Large)
    }
}

private extension View {
    func sectionDescriptionStyle() -> some View {
        self
            .font(.AppFont.rooneySansBold.size(FontSize.xLarge))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, Spacing.large)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let settingsDependencies = dependencies.destinationDependencies.main.settings

    let viewModel = NotificationSettingsViewModel(
        dataManager: DataManager(context: context),
        reminderScheduler: settingsDependencies.reminderScheduler,
        userDefaultsStorage: settingsDependencies.userDefaultsStorage
    )

    NavigationStack {
        NotificationSettingsView(viewModel: viewModel)
            .environmentObject(dependencies.themeManager)
    }
}
