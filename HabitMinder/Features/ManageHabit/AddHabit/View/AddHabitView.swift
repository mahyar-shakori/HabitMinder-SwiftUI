//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI

struct AddHabitView: View {
    private var addHabitViewModel: AddHabitViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.openURL) private var openURL
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    @State private var newReminderTime = Date()

    init(addHabitViewModel: AddHabitViewModel) {
        self.addHabitViewModel = addHabitViewModel
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.x5Large) {
                    pageIntro
                    content
                }
                .padding(.horizontal, Spacing.x3Large)
                .padding(.top, Spacing.x3Large)
                .padding(.bottom, Size.x5Large + Spacing.x8Large)
            }
            .scrollIndicators(.hidden)

            startButton
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
        .alert(
            L10n.AddHabitPage.notificationAlertTitle,
            isPresented: Binding(
                get: { addHabitViewModel.isNotificationSettingsAlertPresented },
                set: { isPresented in
                    if isPresented.not {
                        addHabitViewModel.dismissNotificationSettingsAlert()
                    }
                }
            )
        ) {
            if addHabitViewModel.notificationAlertOpensAppSettings {
                Button(L10n.AddHabitPage.notificationSettingsButton) {
                    addHabitViewModel.dismissNotificationSettingsAlert()
                    openAppSettings()
                }
                Button(L10n.Shared.cancelButton, role: .cancel) {
                    addHabitViewModel.dismissNotificationSettingsAlert()
                }
            } else {
                Button(L10n.Shared.okButton) {
                    addHabitViewModel.dismissNotificationSettingsAlert()
                }
            }
        } message: {
            Text(notificationAlertMessage)
        }
    }
    
    private var content: some View {
        HabitFormView(
            habitTitle: $tempHabitTitle,
            reminderTime: $newReminderTime,
            selectedIconName: addHabitViewModel.selectedIconName,
            selectedFrequency: addHabitViewModel.selectedFrequency,
            selectedCustomWeekdays: addHabitViewModel.selectedCustomWeekdays,
            commitmentDays: addHabitViewModel.commitmentDays,
            reminderTimes: addHabitViewModel.reminderTimes,
            showsFutureHabitToggle: true,
            isFutureHabit: addHabitViewModel.isFutureHabit,
            focus: $isFocused,
            onHabitTitleChange: addHabitViewModel.setHabitTitle,
            onIconSelect: addHabitViewModel.setSelectedIconName,
            onFrequencySelect: addHabitViewModel.setSelectedFrequency,
            onCustomWeekdayToggle: addHabitViewModel.toggleCustomWeekday,
            onCommitmentDaysIncrement: addHabitViewModel.incrementCommitmentDays,
            onCommitmentDaysDecrement: addHabitViewModel.decrementCommitmentDays,
            onReminderTimeAdd: addHabitViewModel.addReminderTime,
            onReminderTimeRemove: addHabitViewModel.removeReminderTime,
            onFutureHabitChange: addHabitViewModel.setIsFutureHabit
        )
    }

    private var notificationAlertMessage: String {
        addHabitViewModel.notificationAlertOpensAppSettings
            ? L10n.AddHabitPage.notificationAlertMessage
            : L10n.AddHabitPage.inAppNotificationAlertMessage
    }

    private var pageIntro: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(L10n.AddHabitPage.title)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(L10n.AddHabitPage.introDescription)
                .font(.AppFont.rooneySansRegular.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var startButton: some View {
        AppPrimaryButton(
            title: L10n.AddHabitPage.startJourneyButton,
            systemImage: SystemIconName.sparkles,
            isEnabled: addHabitViewModel.isSaveButtonEnabled,
            size: .large,
            action: addHabitViewModel.saveAndDismiss
        )
        .padding(.horizontal, Spacing.x3Large)
        .padding(.bottom, Spacing.x5Large)
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(url)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let manageHabitDependencies = dependencies.destinationDependencies.main.manageHabit
    let fakeCoordinator = AddHabitCoordinator(dismiss: {
    })
    let viewModel = AddHabitViewModel(
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        reminderScheduler: manageHabitDependencies.reminderScheduler
    )
    AddHabitView(addHabitViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
