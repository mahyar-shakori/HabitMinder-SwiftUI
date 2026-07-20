//
//  AddHabitView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 04/04/2025.
//

import SwiftUI
import UIKit

struct AddHabitView: View {
    @StateObject private var addHabitViewModel: AddHabitViewModel
    @Environment(\.openURL) private var openURL
    @FocusState private var isFocused: Bool
    @State private var tempHabitTitle = ""
    @State private var newReminderTime = Date()

    init(addHabitViewModel: AddHabitViewModel) {
        _addHabitViewModel = StateObject(wrappedValue: addHabitViewModel)
    }

    var body: some View {
        VStack(spacing: HabitFormConstants.Metrics.rootSpacing) {
            ScrollView {
                VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.contentSpacing) {
                    habitIdentitySection
                    visualAnchorSection
                    commitmentSection
                    habitTypeSection
                    frequencySection
                    reminderSection
                }
                .padding(.horizontal, HabitFormConstants.Metrics.contentHorizontalPadding)
                .padding(.top, HabitFormConstants.Metrics.contentTopPadding)
                .padding(.bottom, HabitFormConstants.Metrics.contentBottomPadding)
            }
            .scrollIndicators(.hidden)

            startButton
        }
        .background(.appGray)
        .dismissKeyboard(focus: $isFocused)
        .alert(
            LocalizedStrings.AddHabitPage.notificationAlertTitle,
            isPresented: Binding(
                get: { addHabitViewModel.uiState.isNotificationSettingsAlertPresented },
                set: { isPresented in
                    if isPresented.not {
                        addHabitViewModel.dismissNotificationSettingsAlert()
                    }
                }
            )
        ) {
            Button(LocalizedStrings.AddHabitPage.notificationSettingsButton) {
                addHabitViewModel.dismissNotificationSettingsAlert()
                openAppSettings()
            }
            Button(LocalizedStrings.Shared.cancelButton, role: .cancel) {
                addHabitViewModel.dismissNotificationSettingsAlert()
            }
        } message: {
            Text(LocalizedStrings.AddHabitPage.notificationAlertMessage)
        }
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
                    addHabitViewModel.setHabitTitle(newValue)
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

    private var habitTypeSection: some View {
        formCard {
            Toggle(LocalizedStrings.AddHabitPage.futureHabitToggle, isOn: Binding(
                get: { addHabitViewModel.uiState.isFutureHabit },
                set: { addHabitViewModel.setIsFutureHabit($0) }
            ))
            .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.valueFontSize - LineWidth.thin))
            .foregroundStyle(.primary)
            .tint(.appPrimary)
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

                if addHabitViewModel.uiState.selectedFrequency == .custom {
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

    private var commitmentSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: HabitFormConstants.Metrics.formCardSpacing) {
                Label(LocalizedStrings.AddHabitPage.commitmentSectionTitle, systemImage: AppIconName.link)
                    .font(.AppFont.rooneySansBold.size(HabitFormConstants.Metrics.labelFontSize))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(HabitFormConstants.Metrics.formHeaderOpacity))

                HStack {
                    Text(LocalizedStrings.AddHabitPage.commitmentDays(addHabitViewModel.uiState.commitmentDays))
                        .font(.AppFont.rooneySansRegular.size(HabitFormConstants.Metrics.valueFontSize))
                        .foregroundStyle(.appPrimary)

                    Spacer()

                    stepperButton(systemImage: AppIconName.minus) {
                        addHabitViewModel.decrementCommitmentDays()
                    }

                    stepperButton(systemImage: AppIconName.plus) {
                        addHabitViewModel.incrementCommitmentDays()
                    }
                }
            }
        }
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
                        addHabitViewModel.addReminderTime(formattedReminderTime(newReminderTime))
                    }
                }

                if addHabitViewModel.uiState.reminderTimes.isNotEmpty {
                    VStack(spacing: HabitFormConstants.Metrics.weekdayGridSpacing) {
                        ForEach(addHabitViewModel.uiState.reminderTimes, id: \.self) { time in
                            reminderRow(time)
                        }
                    }
                    .padding(.top, HabitFormConstants.Metrics.reminderListTopPadding)
                }
            }
        }
    }

    private var startButton: some View {
        AppButton(
            LocalizedStrings.AddHabitPage.startJourneyButton,
            systemImage: AppIconName.sparkles,
            isEnabled: addHabitViewModel.uiState.isSaveButtonEnabled
        ) {
            addHabitViewModel.saveAndDismiss()
        }
        .shadow(
            color: .appPrimary.opacity(HabitFormConstants.Metrics.startButtonShadowOpacity),
            radius: HabitFormConstants.Metrics.startButtonShadowRadius,
            y: HabitFormConstants.Metrics.startButtonShadowY
        )
        .padding(.horizontal, HabitFormConstants.Metrics.contentHorizontalPadding)
        .padding(.top, HabitFormConstants.Metrics.startButtonTopPadding)
        .padding(.bottom, HabitFormConstants.Metrics.contentBottomPadding)
        .background(.appGray)
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
            isSelected: addHabitViewModel.uiState.selectedIconName == icon
        ) {
            addHabitViewModel.setSelectedIconName(icon)
        }
    }

    private func frequencyButton(_ frequency: HabitFrequency) -> some View {
        SelectableChipButton(
            title: frequency.title,
            isSelected: addHabitViewModel.uiState.selectedFrequency == frequency
        ) {
            addHabitViewModel.setSelectedFrequency(frequency)
        }
    }

    private func customWeekdayButton(_ item: HabitWeekdayItem) -> some View {
        SelectableChipButton(
            title: item.title,
            isSelected: addHabitViewModel.uiState.selectedCustomWeekdays.contains(item.weekday)
        ) {
            addHabitViewModel.toggleCustomWeekday(item.weekday)
        }
    }

    private func reminderRow(_ time: String) -> some View {
        HStack {
            Text(displayReminderTime(time))
                .font(.AppFont.rooneySansRegular.size(HabitFormConstants.Metrics.valueFontSize - LineWidth.thin))
                .foregroundStyle(.appPrimary)

            Spacer()

            InlineIconButton(systemImage: AppIconName.xmark) {
                if let index = addHabitViewModel.uiState.reminderTimes.firstIndex(of: time) {
                    addHabitViewModel.removeReminderTime(at: IndexSet(integer: index))
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
