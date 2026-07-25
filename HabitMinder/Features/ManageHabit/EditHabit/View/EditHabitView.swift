//
//  EditHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import SwiftUI

struct EditHabitView: View {
    private let editHabitViewModel: EditHabitViewModel
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
                    content
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
        .notificationPermissionAlert(
            isPresented: notificationAlertBinding,
            opensAppSettings: editHabitViewModel.notificationAlertOpensAppSettings,
            message: notificationAlertMessage,
            onDismiss: editHabitViewModel.dismissNotificationSettingsAlert,
            onOpenAppSettings: openAppSettings
        )
    }
    
    private var content: some View {
        HabitFormView(
            habitTitle: $tempHabitTitle,
            reminderTime: $newReminderTime,
            selectedIconName: editHabitViewModel.selectedIconName,
            selectedFrequency: editHabitViewModel.selectedFrequency,
            selectedCustomWeekdays: editHabitViewModel.selectedCustomWeekdays,
            commitmentDays: editHabitViewModel.commitmentDays,
            reminderTimes: editHabitViewModel.reminderTimes,
            showsFutureHabitToggle: true,
            isFutureHabit: editHabitViewModel.isFutureHabit,
            focus: $isFocused,
            onHabitTitleChange: editHabitViewModel.setHabitTitle,
            onIconSelect: editHabitViewModel.setSelectedIconName,
            onFrequencySelect: editHabitViewModel.setSelectedFrequency,
            onCustomWeekdayToggle: editHabitViewModel.toggleCustomWeekday,
            onCommitmentDaysIncrement: editHabitViewModel.incrementCommitmentDays,
            onCommitmentDaysDecrement: editHabitViewModel.decrementCommitmentDays,
            onReminderTimeAdd: editHabitViewModel.addReminderTime,
            onReminderTimeRemove: editHabitViewModel.removeReminderTime,
            onFutureHabitChange: editHabitViewModel.setIsFutureHabit
        )
    }
    
    private var notificationAlertBinding: Binding<Bool> {
        Binding(
            get: { editHabitViewModel.isNotificationSettingsAlertPresented },
            set: { isPresented in
                if isPresented.not {
                    editHabitViewModel.dismissNotificationSettingsAlert()
                }
            }
        )
    }

    private var notificationAlertMessage: String {
        editHabitViewModel.notificationAlertOpensAppSettings
            ? L10n.AddHabitPage.notificationAlertMessage
            : L10n.AddHabitPage.inAppNotificationAlertMessage
    }

    private var pageIntro: some View {
        PageIntroView(
            title: L10n.EditHabitPage.title,
            description: L10n.EditHabitPage.introDescription,
            topPadding: Spacing.none
        ) {
            Spacer()
            saveButton
        }
    }

    private var saveButton: some View {
        AppPrimaryButton(
            title: L10n.Shared.saveButton,
            isEnabled: editHabitViewModel.isSaveButtonEnabled,
            fillsWidth: false,
            size: .large
        ) {
            isFocused = false
            editHabitViewModel.saveAndDismiss()
        }
    }
    
    private var floatingBottomControls: some View {
        VStack(spacing: Spacing.small) {
            if editHabitViewModel.showToast {
                ToastLabel(text: L10n.EditHabitPage.missHabitToast)
            }
            missHabitButton
        }
        .padding(.horizontal, Spacing.x7Large)
        .padding(.bottom, Spacing.x5Large)
    }
   
    private var missHabitButton: some View {
        AppPrimaryButton(
            title: L10n.EditHabitPage.missHabitButton,
            isEnabled: editHabitViewModel.showToast.not,
            size: .large
        ) {
            withAnimation {
                editHabitViewModel.missHabitAndShowToast()
            }
        }
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
