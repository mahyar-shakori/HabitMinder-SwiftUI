//
//  EditHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/06/2025.
//

import SwiftUI
import UIKit

struct EditHabitView: View {
    @StateObject private var editHabitViewModel: EditHabitViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.openURL) private var openURL
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    @State private var newReminderTime = Date()
    
    init(editHabitViewModel: EditHabitViewModel) {
        _editHabitViewModel = StateObject(wrappedValue: editHabitViewModel)
    }
    
    var body: some View {
        VStack(spacing: HabitFormConstants.Metrics.rootSpacing) {
            topViews

            ScrollView {
                VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.contentSpacing) {
                    habitIdentitySection
                    visualAnchorSection
                    commitmentSection
                    frequencySection
                    reminderSection
                }
                .padding(.horizontal, HabitFormConstants.Metrics.contentHorizontalPadding)
                .padding(.top, HabitFormConstants.Metrics.contentTopPadding)
                .padding(.bottom, HabitFormConstants.Metrics.contentBottomPadding)
            }
            .scrollIndicators(.hidden)

            if editHabitViewModel.uiState.showToast {
                toastLabel
            }

            bottomButtons
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
//        .navigationBarBackButtonHidden(true)
        .onAppear {
            tempHabitTitle = editHabitViewModel.uiState.habitTitle
        }
        .alert(
            LocalizedStrings.AddHabitPage.notificationAlertTitle,
            isPresented: Binding(
                get: { editHabitViewModel.uiState.isNotificationSettingsAlertPresented },
                set: { isPresented in
                    if isPresented.not {
                        editHabitViewModel.dismissNotificationSettingsAlert()
                    }
                }
            )
        ) {
            Button(LocalizedStrings.AddHabitPage.notificationSettingsButton) {
                editHabitViewModel.dismissNotificationSettingsAlert()
                openAppSettings()
            }
            Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                editHabitViewModel.dismissNotificationSettingsAlert()
            }
        } message: {
            Text(LocalizedStrings.AddHabitPage.notificationAlertMessage)
        }
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.EditHabitPage.title)
            .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.topTitleFontSize))
    }
    
    private var saveButton: some View {
        AppButton(
            LocalizedStrings.Shared.saveButton,
            variant: .compactPrimary,
            isEnabled: editHabitViewModel.uiState.isSaveButtonEnabled
        ) {
            editHabitViewModel.saveAndDismiss()
        }
    }
    
    private var topViews: some View {
        HStack(spacing: HabitFormConstants.Metrics.topBarSpacing) {
            titleText
            Spacer()
            saveButton
        }
        .padding(.horizontal, HabitFormConstants.Metrics.contentHorizontalPadding)
        .padding(.top, HabitFormConstants.Metrics.topBarTopPadding)
    }


    private var habitIdentitySection: some View {
        VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.sectionSpacing) {
            sectionTitle(LocalizedStrings.AddHabitPage.identitySectionTitle)

            TextField(LocalizedStrings.AddHabitPage.titlePlaceholder, text: $tempHabitTitle)
                .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.titleFontSize))
                .foregroundStyle(.primary)
                .padding(.horizontal, HabitFormConstants.Metrics.textFieldHorizontalPadding)
                .frame(height: HabitFormConstants.Metrics.textFieldHeight)
                .background(.appGray)
                .overlay {
                    Rectangle()
                        .stroke(.appPrimary.opacity(HabitFormConstants.Metrics.fieldBorderOpacity), lineWidth: LineWidth.thin)
                }
                .focused($isFocused)
                .submitLabel(.done)
                .onChange(of: tempHabitTitle) { _, newValue in
                    editHabitViewModel.setHabitTitle(newValue)
                }
        }
    }

    private var visualAnchorSection: some View {
        VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.sectionSpacing) {
            HStack {
                sectionTitle(LocalizedStrings.AddHabitPage.visualAnchorSectionTitle)
                Spacer()
                Text(LocalizedStrings.AddHabitPage.selectIconHint)
                    .font(.AppFont.rooneySansRegular.size(HabitFormConstants.Metrics.hintFontSize))
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: HabitFormConstants.Metrics.iconGridSpacing),
                    count: HabitFormConstants.Metrics.gridColumnCount
                ),
                spacing: HabitFormConstants.Metrics.iconGridSpacing
            ) {
                ForEach(iconNames, id: \.self) { icon in
                    iconButton(icon)
                }
            }
        }
    }

    private var commitmentSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.formCardSpacing) {
                Label(LocalizedStrings.AddHabitPage.commitmentSectionTitle, systemImage: AppIconName.link)
                    .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.labelFontSize))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(HabitFormConstants.Metrics.formHeaderOpacity))

                HStack {
                    Text(LocalizedStrings.AddHabitPage.commitmentDays(editHabitViewModel.uiState.commitmentDays))
                        .font(.AppFont.rooneySansRegular.size(HabitFormConstants.Metrics.valueFontSize))
                        .foregroundStyle(.appPrimary)

                    Spacer()

                    stepperButton(systemImage: AppIconName.minus) {
                        editHabitViewModel.decrementCommitmentDays()
                    }

                    stepperButton(systemImage: AppIconName.plus) {
                        editHabitViewModel.incrementCommitmentDays()
                    }
                }
            }
        }
    }

    private var frequencySection: some View {
        formCard {
            VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.sectionSpacing) {
                Label(LocalizedStrings.AddHabitPage.frequencySectionTitle, systemImage: AppIconName.calendar)
                    .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.labelFontSize))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(HabitFormConstants.Metrics.formHeaderOpacity))

                HStack(spacing: HabitFormConstants.Metrics.chipSpacing) {
                    ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                        frequencyButton(frequency)
                    }
                }

                if editHabitViewModel.uiState.selectedFrequency == .custom {
                    customWeekdayPicker
                }
            }
        }
    }

    private var customWeekdayPicker: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: HabitFormConstants.Metrics.weekdayGridSpacing),
                count: HabitFormConstants.Metrics.gridColumnCount
            ),
            spacing: HabitFormConstants.Metrics.weekdayGridSpacing
        ) {
            ForEach(customWeekdays, id: \.weekday) { item in
                customWeekdayButton(item)
            }
        }
        .padding(.top, Spacing.x3Small)
    }

    private var reminderSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.reminderSectionSpacing) {
                Label(LocalizedStrings.AddHabitPage.reminderSectionTitle, systemImage: AppIconName.bell)
                    .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.labelFontSize))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(HabitFormConstants.Metrics.formHeaderOpacity))

                Text(LocalizedStrings.AddHabitPage.reminderSubtitle)
                    .font(.AppFont.rooneySansRegular.size(HabitFormConstants.Metrics.bodyFontSize))
                    .foregroundStyle(.secondary)

                HStack(spacing: HabitFormConstants.Metrics.sectionSpacing) {
                    DatePicker("", selection: $newReminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    stepperButton(systemImage: AppIconName.plus) {
                        editHabitViewModel.addReminderTime(formattedReminderTime(newReminderTime))
                    }
                }

                if editHabitViewModel.uiState.reminderTimes.isNotEmpty {
                    VStack(spacing: HabitFormConstants.Metrics.weekdayGridSpacing) {
                        ForEach(editHabitViewModel.uiState.reminderTimes, id: \.self) { time in
                            reminderRow(time)
                        }
                    }
                    .padding(.top, HabitFormConstants.Metrics.reminderListTopPadding)
                }
            }
        }
    }
    
    private var toastLabel: some View {
        Text(LocalizedStrings.EditHabitPage.missHabitToast)
            .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.toastFontSize))
            .foregroundColor(.appWhite)
            .padding(.vertical, HabitFormConstants.Metrics.toastVerticalPadding)
            .padding(.horizontal, HabitFormConstants.Metrics.textFieldHorizontalPadding)
            .background(.primary.opacity(HabitFormConstants.Metrics.toastOpacity))
            .cornerRadius(HabitFormConstants.Metrics.toastCornerRadius)
            .transition(.opacity.combined(with: .scale))
            .padding(.bottom, HabitFormConstants.Metrics.toastBottomPadding)
    }

    private var bottomButtons: some View {
        VStack(spacing: HabitFormConstants.Metrics.bottomButtonSpacing) {
            missHabitButton
        }
        .padding(.bottom, HabitFormConstants.Metrics.bottomButtonsBottomPadding)
        .background(.appGray)
    }
   
    private var missHabitButton: some View {
        AppButton(
            LocalizedStrings.EditHabitPage.missHabitButton,
            isEnabled: editHabitViewModel.uiState.showToast.not
        ) {
            withAnimation {
                editHabitViewModel.missHabitAndShowToast()
            }
        }
        .padding(.horizontal, HabitFormConstants.Metrics.missButtonHorizontalPadding)
        .padding(.bottom, HabitFormConstants.Metrics.missButtonBottomPadding)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.labelFontSize))
            .tracking(2)
            .foregroundStyle(.primary.opacity(0.72))
    }

    private func iconButton(_ icon: String) -> some View {
        SelectableIconButton(
            systemImage: icon,
            isSelected: editHabitViewModel.uiState.selectedIconName == icon
        ) {
            editHabitViewModel.setSelectedIconName(icon)
        }
    }

    private func frequencyButton(_ frequency: HabitFrequency) -> some View {
        SelectableChipButton(
            title: frequency.title,
            isSelected: editHabitViewModel.uiState.selectedFrequency == frequency
        ) {
            editHabitViewModel.setSelectedFrequency(frequency)
        }
    }

    private func customWeekdayButton(_ item: HabitWeekdayItem) -> some View {
        SelectableChipButton(
            title: item.title,
            isSelected: editHabitViewModel.uiState.selectedCustomWeekdays.contains(item.weekday)
        ) {
            editHabitViewModel.toggleCustomWeekday(item.weekday)
        }
    }

    private func reminderRow(_ time: String) -> some View {
        HStack {
            Text(displayReminderTime(time))
                .font(.AppFont.rooneySansRegular.size(HabitFormConstants.Metrics.valueFontSize - LineWidth.thin))
                .foregroundStyle(.appPrimary)

            Spacer()

            InlineIconButton(systemImage: AppIconName.xmark) {
                if let index = editHabitViewModel.uiState.reminderTimes.firstIndex(of: time) {
                    editHabitViewModel.removeReminderTime(at: IndexSet(integer: index))
                }
            }
        }
        .padding(.horizontal, HabitFormConstants.Metrics.reminderRowHorizontalPadding)
        .padding(.vertical, HabitFormConstants.Metrics.reminderRowVerticalPadding)
        .background(.appPrimary.opacity(HabitFormConstants.Metrics.reminderRowOpacity))
        .clipShape(RoundedRectangle(cornerRadius: HabitFormConstants.Metrics.reminderRowCornerRadius))
    }

    private func stepperButton(
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        InlineIconButton(
            systemImage: systemImage,
            variant: .outlinedCircle,
            size: HabitFormConstants.Metrics.stepperSize,
            fontSize: HabitFormConstants.Metrics.stepperFontSize,
            fontWeight: .semibold,
            action: action
        )
    }

    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(HabitFormConstants.Metrics.formCardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.appGray)
            .overlay {
                RoundedRectangle(cornerRadius: HabitFormConstants.Metrics.formCardCornerRadius)
                    .stroke(.appPrimary.opacity(0.08), lineWidth: LineWidth.thin)
            }
            .clipShape(RoundedRectangle(cornerRadius: HabitFormConstants.Metrics.formCardCornerRadius))
    }

    private func formattedReminderTime(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let hourText = paddedTimeComponent(hour)
        let minuteText = paddedTimeComponent(minute)
        return [hourText, minuteText].joined(separator: HabitFormConstants.DateFormat.separator)
    }

    private func paddedTimeComponent(_ value: Int) -> String {
        let valueText = value.description
        guard value < HabitFormConstants.DateFormat.paddedComponentThreshold else {
            return valueText
        }

        return HabitFormConstants.DateFormat.zeroPrefix + valueText
    }

    private func displayReminderTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = HabitFormConstants.DateFormat.storageTime

        guard let date = formatter.date(from: time) else {
            return time
        }

        formatter.dateFormat = HabitFormConstants.DateFormat.displayTime
        return formatter.string(from: date)
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(url)
    }

    private var customWeekdays: [HabitWeekdayItem] {
        HabitFormConstants.weekdays
    }

    private var iconNames: [String] {
        HabitFormConstants.iconNames
    }
}


#Preview {
    @Previewable @Environment(\.modelContext) var context

    let dependencies = AppDependencies()
    let manageHabitDependencies = dependencies.destinationDependencies.main.manageHabit
    
    let sampleHabit = HabitModel(title: LocalizedStrings.AddHabitPage.titlePlaceholder)
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
