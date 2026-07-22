//
//  NotificationSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    private var viewModel: NotificationSettingsViewModel

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
                PageIntroView(
                    title: L10n.NotificationSettings.introTitle,
                    description: L10n.NotificationSettings.introDescription
                )
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

    private var generalSection: some View {
        SettingsSection(title: L10n.NotificationSettings.general, style: .primary) {
            SettingsToggleRow(
                iconName: SystemIconName.bell,
                title: L10n.NotificationSettings.allowNotifications,
                isOn: allowNotificationsBinding
            )

            Text(L10n.NotificationSettings.allowNotificationsDescription)
                .sectionDescriptionStyle()
        }
    }

    private var ritualRemindersSection: some View {
        SettingsSection(title: L10n.NotificationSettings.ritualReminders, style: .primary) {
            VStack(spacing: Spacing.none) {
                SettingsToggleRow(
                    iconName: SystemIconName.calendar,
                    title: L10n.NotificationSettings.dailyReminders,
                    isOn: dailyRemindersBinding,
                    isEnabled: viewModel.allowNotifications,
                    clipsBackground: false
                )

                Divider()
                    .padding(.leading, Size.x3Large + Spacing.x3Large)

                SettingsToggleRow(
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
        SettingsSection(title: L10n.NotificationSettings.motivation, style: .primary) {
            SettingsToggleRow(
                iconName: SystemIconName.quoteBubble,
                title: L10n.NotificationSettings.dailyQuotes,
                isOn: dailyQuotesBinding
            )

            Text(L10n.NotificationSettings.dailyQuotesDescription)
                .sectionDescriptionStyle()
        }
    }
}

private extension View {
    func sectionDescriptionStyle() -> some View {
        self
            .font(.AppFont.rooneySansRegular.size(FontSize.medium))
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
