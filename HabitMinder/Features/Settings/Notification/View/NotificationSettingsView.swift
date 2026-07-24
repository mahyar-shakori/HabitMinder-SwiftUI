//
//  NotificationSettingsView.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    private let notificationSettingsViewModel: NotificationSettingsViewModel

    init(notificationSettingsViewModel: NotificationSettingsViewModel) {
        self.notificationSettingsViewModel = notificationSettingsViewModel
    }

    private var allowNotificationsBinding: Binding<Bool> {
        Binding {
            notificationSettingsViewModel.allowNotifications
        } set: { isOn in
            notificationSettingsViewModel.setAllowNotifications(isOn)
        }
    }

    private var dailyRemindersBinding: Binding<Bool> {
        Binding {
            notificationSettingsViewModel.dailyRemindersToggleValue
        } set: { isOn in
            notificationSettingsViewModel.setDailyReminders(isOn)
        }
    }

    private var journeyCompletionBinding: Binding<Bool> {
        Binding {
            notificationSettingsViewModel.journeyCompletionToggleValue
        } set: { isOn in
            notificationSettingsViewModel.setJourneyCompletionNotifications(isOn)
        }
    }

    private var dailyQuotesBinding: Binding<Bool> {
        Binding {
            notificationSettingsViewModel.dailyQuotes
        } set: { isOn in
            notificationSettingsViewModel.setDailyQuotes(isOn)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.x5Large) {
                PageIntroView(
                    title: L10n.NotificationPage.introTitle,
                    description: L10n.NotificationPage.introDescription
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
        .navigationTitle(L10n.SettingsPage.notifications)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var generalSection: some View {
        SettingsSection(title: L10n.NotificationPage.general, style: .primary) {
            SettingsToggleRow(
                iconName: SystemIconName.bell,
                title: L10n.NotificationPage.allowNotifications,
                isOn: allowNotificationsBinding
            )

            Text(L10n.NotificationPage.allowNotificationsDescription)
                .sectionDescriptionStyle()
        }
    }

    private var ritualRemindersSection: some View {
        SettingsSection(title: L10n.NotificationPage.ritualReminders, style: .primary) {
            VStack(spacing: Spacing.none) {
                SettingsToggleRow(
                    iconName: SystemIconName.calendar,
                    title: L10n.NotificationPage.dailyReminders,
                    isOn: dailyRemindersBinding,
                    isEnabled: notificationSettingsViewModel.allowNotifications,
                    clipsBackground: false
                )

                Divider()
                    .padding(.leading, Size.x3Large + Spacing.x3Large)

                SettingsToggleRow(
                    iconName: SystemIconName.sparkles,
                    title: L10n.NotificationPage.journeyCompletion,
                    isOn: journeyCompletionBinding,
                    isEnabled: notificationSettingsViewModel.allowNotifications,
                    clipsBackground: false
                )
            }
            .background(.appWhite)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))

            Text(L10n.NotificationPage.journeyCompletionDescription)
                .sectionDescriptionStyle()
        }
    }

    private var motivationSection: some View {
        SettingsSection(title: L10n.NotificationPage.motivation, style: .primary) {
            SettingsToggleRow(
                iconName: SystemIconName.quoteBubble,
                title: L10n.NotificationPage.dailyQuotes,
                isOn: dailyQuotesBinding
            )

            Text(L10n.NotificationPage.dailyQuotesDescription)
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
        NotificationSettingsView(notificationSettingsViewModel: viewModel)
            .environmentObject(dependencies.themeManager)
    }
}
