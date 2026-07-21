//
//  EditHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import SwiftUI

struct EditHabitView: View {
    private var editHabitViewModel: EditHabitViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.openURL) private var openURL
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    @State private var newReminderTime = Date()
    
    init(editHabitViewModel: EditHabitViewModel) {
        self.editHabitViewModel = editHabitViewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.x5Large) {
                    pageIntro

                    HabitFormView(
                        habitTitle: $tempHabitTitle,
                        reminderTime: $newReminderTime,
                        selectedIconName: editHabitViewModel.selectedIconName,
                        selectedFrequency: editHabitViewModel.selectedFrequency,
                        selectedCustomWeekdays: editHabitViewModel.selectedCustomWeekdays,
                        commitmentDays: editHabitViewModel.commitmentDays,
                        reminderTimes: editHabitViewModel.reminderTimes,
                        showsFutureHabitToggle: false,
                        isFutureHabit: false,
                        focus: $isFocused,
                        onHabitTitleChange: editHabitViewModel.setHabitTitle,
                        onIconSelect: editHabitViewModel.setSelectedIconName,
                        onFrequencySelect: editHabitViewModel.setSelectedFrequency,
                        onCustomWeekdayToggle: editHabitViewModel.toggleCustomWeekday,
                        onCommitmentDaysIncrement: editHabitViewModel.incrementCommitmentDays,
                        onCommitmentDaysDecrement: editHabitViewModel.decrementCommitmentDays,
                        onReminderTimeAdd: editHabitViewModel.addReminderTime,
                        onReminderTimeRemove: editHabitViewModel.removeReminderTime,
                        onFutureHabitChange: { _ in }
                    )
                }
                .padding(.horizontal, Spacing.x3Large)
                .padding(.top, Spacing.x3Large)
                .padding(.bottom, Size.x5Large + Spacing.x8Large)
            }
            .scrollIndicators(.hidden)

            floatingBottomControls
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
        .onAppear {
            tempHabitTitle = editHabitViewModel.habitTitle
        }
        .alert(
            L10n.AddHabitPage.notificationAlertTitle,
            isPresented: Binding(
                get: { editHabitViewModel.isNotificationSettingsAlertPresented },
                set: { isPresented in
                    if isPresented.not {
                        editHabitViewModel.dismissNotificationSettingsAlert()
                    }
                }
            )
        ) {
            if editHabitViewModel.notificationAlertOpensAppSettings {
                Button(L10n.AddHabitPage.notificationSettingsButton) {
                    editHabitViewModel.dismissNotificationSettingsAlert()
                    openAppSettings()
                }
                Button(L10n.Shared.cancelButton, role: .cancel) {
                    editHabitViewModel.dismissNotificationSettingsAlert()
                }
            } else {
                Button(L10n.Shared.okButton) {
                    editHabitViewModel.dismissNotificationSettingsAlert()
                }
            }
        } message: {
            Text(notificationAlertMessage)
        }
    }
    
    private var notificationAlertMessage: String {
        editHabitViewModel.notificationAlertOpensAppSettings
            ? L10n.AddHabitPage.notificationAlertMessage
            : L10n.AddHabitPage.inAppNotificationAlertMessage
    }

    private var pageIntro: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            HStack(spacing: Spacing.medium) {
                Text(L10n.EditHabitPage.title)
                    .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                    .foregroundStyle(.primary)

                Spacer()

                saveButton
            }

            Text(L10n.EditHabitPage.introDescription)
                .font(.AppFont.rooneySansRegular.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var saveButton: some View {
        Button(L10n.Shared.saveButton) {
            editHabitViewModel.saveAndDismiss()
        }
        .font(.AppFont.rooneySansBold.size(FontSize.medium))
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .buttonBorderShape(.capsule)
        .tint(editHabitViewModel.isSaveButtonEnabled ? themeManager.appPrimary : themeManager.appSecondary)
        .disabled(editHabitViewModel.isSaveButtonEnabled.not)
    }
    
    private var toastLabel: some View {
        Text(L10n.EditHabitPage.missHabitToast)
            .font(.AppFont.rooneySansBold.size(FontSize.x2Large))
            .foregroundColor(.appWhite)
            .padding(.vertical, Spacing.xSmall)
            .padding(.horizontal, Spacing.xLarge)
            .background(.primary.opacity(Opacity.toastBackground))
            .cornerRadius(CornerRadius.medium)
            .transition(.opacity.combined(with: .scale))
            .padding(.bottom, Spacing.xSmall)
    }

    private var floatingBottomControls: some View {
        VStack(spacing: Spacing.small) {
            if editHabitViewModel.showToast {
                toastLabel
            }

            missHabitButton
        }
        .padding(.horizontal, Spacing.x7Large)
        .padding(.bottom, Spacing.x5Large)
    }
   
    private var missHabitButton: some View {
        Button {
            withAnimation {
                editHabitViewModel.missHabitAndShowToast()
            }
        } label: {
            Text(L10n.EditHabitPage.missHabitButton)
                .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .tint(editHabitViewModel.showToast.not ? themeManager.appPrimary : themeManager.appSecondary)
        .disabled(editHabitViewModel.showToast)
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
    
    let sampleHabit = HabitModel(title: L10n.AddHabitPage.titlePlaceholder)
    let fakeCoordinator = EditHabitCoordinator(dismiss: {
    })
    let viewModel = EditHabitViewModel(
        dataManager: DataManager(context: context),
        coordinator: fakeCoordinator,
        habitID: sampleHabit.id,
        reminderScheduler: manageHabitDependencies.reminderScheduler
    )
    EditHabitView(editHabitViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
