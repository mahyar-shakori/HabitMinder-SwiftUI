//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI
import UIKit

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
        VStack(spacing: Spacing.none) {
            ScrollView {
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
                .padding(.horizontal, Spacing.x3Large)
                .padding(.top, Spacing.x3Large)
                .padding(.bottom, Spacing.x5Large)
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
            Button(L10n.AddHabitPage.notificationSettingsButton) {
                addHabitViewModel.dismissNotificationSettingsAlert()
                openAppSettings()
            }
            Button(L10n.Shared.cancelButton, role: .cancel) {
                addHabitViewModel.dismissNotificationSettingsAlert()
            }
        } message: {
            Text(L10n.AddHabitPage.notificationAlertMessage)
        }
    }

    private var startButton: some View {
        Button {
            addHabitViewModel.saveAndDismiss()
        } label: {
            Label(L10n.AddHabitPage.startJourneyButton, systemImage: SystemIconName.sparkles)
                .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .tint(addHabitViewModel.isSaveButtonEnabled ? themeManager.appPrimary : themeManager.appSecondary)
        .disabled(addHabitViewModel.isSaveButtonEnabled.not)
        .padding(.horizontal, Spacing.x3Large)
        .padding(.top, Spacing.medium)
        .padding(.bottom, Spacing.x5Large)
        .background(.appGray)
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
