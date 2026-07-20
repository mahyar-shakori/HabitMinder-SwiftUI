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
        VStack(spacing: Spacing.none) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.x5Large) {
                    habitIdentitySection
                    visualAnchorSection
                    commitmentSection
                    habitTypeSection
                    frequencySection
                    reminderSection
                }
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
                get: { addHabitViewModel.uiState.isNotificationSettingsAlertPresented },
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

    private var habitIdentitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            sectionTitle(L10n.AddHabitPage.identitySectionTitle)

            TextField(L10n.AddHabitPage.titlePlaceholder, text: $tempHabitTitle)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)
                .padding(.horizontal, Spacing.xLarge)
                .frame(height: Size.x4Large)
                .background(.appGray)
                .overlay {
                    Rectangle()
                        .stroke(.appPrimary.opacity(Opacity.fieldBorder), lineWidth: LineWidth.thin)
                }
                .focused($isFocused)
                .submitLabel(.done)
                .onChange(of: tempHabitTitle) { _, newValue in
                    addHabitViewModel.setHabitTitle(newValue)
                }
        }
    }

    private var visualAnchorSection: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            HStack {
                sectionTitle(L10n.AddHabitPage.visualAnchorSectionTitle)
                Spacer()
                Text(L10n.AddHabitPage.selectIconHint)
                    .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: Spacing.x2Large),
                    count: LayoutCount.four
                ),
                spacing: Spacing.x2Large
            ) {
                ForEach(iconNames, id: \.self) { icon in
                    iconButton(icon)
                }
            }
        }
    }

    private var habitTypeSection: some View {
        formCard {
            Toggle(L10n.AddHabitPage.futureHabitToggle, isOn: Binding(
                get: { addHabitViewModel.uiState.isFutureHabit },
                set: { addHabitViewModel.setIsFutureHabit($0) }
            ))
            .font(.AppFont.rooneySansBold.size(FontSize.x2Large - LineWidth.thin))
            .foregroundStyle(.primary)
            .tint(.appPrimary)
        }
    }

    private var frequencySection: some View {
        formCard {
            VStack(alignment: .leading, spacing: Spacing.large) {
                Label(L10n.AddHabitPage.frequencySectionTitle, systemImage: SystemIconName.calendar)
                    .font(.AppFont.rooneySansBold.size(FontSize.small))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(Opacity.formHeader))

                HStack(spacing: Spacing.small) {
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
                repeating: GridItem(.flexible(), spacing: Spacing.xSmall),
                count: LayoutCount.four
            ),
            spacing: Spacing.xSmall
        ) {
            ForEach(customWeekdays, id: \.weekday) { item in
                customWeekdayButton(item)
            }
        }
        .padding(.top, Spacing.x3Small)
    }

    private var commitmentSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: Spacing.x3Large) {
                Label(L10n.AddHabitPage.commitmentSectionTitle, systemImage: SystemIconName.link)
                    .font(.AppFont.rooneySansBold.size(FontSize.small))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(Opacity.formHeader))

                HStack {
                    Text(L10n.AddHabitPage.commitmentDays(addHabitViewModel.uiState.commitmentDays))
                        .font(.AppFont.rooneySansRegular.size(FontSize.x2Large))
                        .foregroundStyle(.appPrimary)

                    Spacer()

                    stepperButton(systemImage: SystemIconName.minus) {
                        addHabitViewModel.decrementCommitmentDays()
                    }

                    stepperButton(systemImage: SystemIconName.plus) {
                        addHabitViewModel.incrementCommitmentDays()
                    }
                }
            }
        }
    }

    private var reminderSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                Label(L10n.AddHabitPage.reminderSectionTitle, systemImage: SystemIconName.bell)
                    .font(.AppFont.rooneySansBold.size(FontSize.small))
                    .textCase(.uppercase)
                    .foregroundStyle(.primary.opacity(Opacity.formHeader))

                Text(L10n.AddHabitPage.reminderSubtitle)
                    .font(.AppFont.rooneySansRegular.size(FontSize.large))
                    .foregroundStyle(.secondary)

                HStack(spacing: Spacing.large) {
                    DatePicker("", selection: $newReminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    stepperButton(systemImage: SystemIconName.plus) {
                        addHabitViewModel.addReminderTime(formattedReminderTime(newReminderTime))
                    }
                }

                if addHabitViewModel.uiState.reminderTimes.isNotEmpty {
                    VStack(spacing: Spacing.xSmall) {
                        ForEach(addHabitViewModel.uiState.reminderTimes, id: \.self) { time in
                            reminderRow(time)
                        }
                    }
                    .padding(.top, Spacing.x2Small)
                }
            }
        }
    }

    private var startButton: some View {
        AppButton(
            L10n.AddHabitPage.startJourneyButton,
            systemImage: SystemIconName.sparkles,
            isEnabled: addHabitViewModel.uiState.isSaveButtonEnabled
        ) {
            addHabitViewModel.saveAndDismiss()
        }
        .shadow(
            color: .appPrimary.opacity(Opacity.fieldBorder),
            radius: Spacing.small,
            y: Spacing.x2Small
        )
        .padding(.horizontal, Spacing.x3Large)
        .padding(.top, Spacing.medium)
        .padding(.bottom, Spacing.x5Large)
        .background(.appGray)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.AppFont.rooneySansBold.size(FontSize.small))
            .tracking(Spacing.x3Small)
            .foregroundStyle(.primary.opacity(Opacity.sectionTitle))
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
                .font(.AppFont.rooneySansRegular.size(FontSize.x2Large - LineWidth.thin))
                .foregroundStyle(.appPrimary)

            Spacer()

            InlineIconButton(systemImage: SystemIconName.xmark) {
                if let index = addHabitViewModel.uiState.reminderTimes.firstIndex(of: time) {
                    addHabitViewModel.removeReminderTime(at: IndexSet(integer: index))
                }
            }
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.small)
        .background(.appPrimary.opacity(Opacity.quiet))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
    }

    private func stepperButton(
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        InlineIconButton(
            systemImage: systemImage,
            variant: .outlinedCircle,
            size: Size.large,
            fontSize: FontSize.medium,
            fontWeight: .semibold,
            action: action
        )
    }

    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(Spacing.x3Large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.appGray)
            .overlay {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(.appPrimary.opacity(Opacity.quiet), lineWidth: LineWidth.thin)
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
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
