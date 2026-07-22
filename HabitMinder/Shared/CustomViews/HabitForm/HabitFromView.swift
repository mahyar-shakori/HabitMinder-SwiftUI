//
//  HabitFromView.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import SwiftUI

struct HabitFormView: View {
    @Binding var habitTitle: String
    @Binding var reminderTime: Date
    let selectedIconName: String
    let selectedFrequency: HabitFrequency
    let selectedCustomWeekdays: [Int]
    let commitmentDays: Int
    let reminderTimes: [String]
    let showsFutureHabitToggle: Bool
    let isFutureHabit: Bool
    let focus: FocusState<Bool>.Binding
    let onHabitTitleChange: (String) -> Void
    let onIconSelect: (String) -> Void
    let onFrequencySelect: (HabitFrequency) -> Void
    let onCustomWeekdayToggle: (Int) -> Void
    let onCommitmentDaysIncrement: () -> Void
    let onCommitmentDaysDecrement: () -> Void
    let onReminderTimeAdd: (String) -> Void
    let onReminderTimeRemove: (IndexSet) -> Void
    let onFutureHabitChange: (Bool) -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.x5Large) {
            habitIdentitySection
            visualAnchorSection
            commitmentSection

            if showsFutureHabitToggle {
                habitTypeSection
            }

            frequencySection
            reminderSection
        }
    }

    private var habitIdentitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            sectionTitle(L10n.AddHabitPage.identitySectionTitle)

            formRow(systemImage: selectedDisplayIconName) {
                VStack(alignment: .leading, spacing: Spacing.x2Small) {
                    TextField(L10n.AddHabitPage.titlePlaceholder, text: $habitTitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                        .foregroundStyle(.primary)
                        .textInputAutocapitalization(.words)
                        .focused(focus)
                        .submitLabel(.done)
                        .onChange(of: habitTitle) { _, newValue in
                            onHabitTitleChange(newValue)
                        }
                }
            }
        }
    }

    private var visualAnchorSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            sectionTitle(L10n.AddHabitPage.visualAnchorSectionTitle)

            VStack(alignment: .leading, spacing: Spacing.medium) {
                Text(L10n.AddHabitPage.selectIconHint)
                    .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                    .foregroundStyle(.primary)

                ScrollView(.horizontal) {
                    HStack(spacing: Spacing.small) {
                        ForEach(iconNames, id: \.self) { icon in
                            iconButton(icon)
                        }
                    }
                    .padding(.vertical, Spacing.x3Small)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, Spacing.xLarge)
            .padding(.vertical, Spacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.appWhite)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xLarge))
        }
    }

    private var commitmentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            sectionTitle(L10n.AddHabitPage.commitmentSectionTitle)

            formRow(systemImage: SystemIconName.link) {
                Stepper(value: commitmentDaysBinding, in: 1...365) {
                    VStack(alignment: .leading, spacing: Spacing.x2Small) {
                        Text(L10n.AddHabitPage.commitmentSectionTitle)
                            .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                            .foregroundStyle(.primary)

                        Text(L10n.AddHabitPage.commitmentDays(commitmentDays))
                            .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var habitTypeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            sectionTitle(L10n.AddHabitPage.futureHabitToggle)

            formRow(systemImage: SystemIconName.calendar) {
                Toggle(isOn: futureHabitBinding) {
                    VStack(alignment: .leading, spacing: Spacing.x2Small) {
                        Text(L10n.AddHabitPage.futureHabitToggle)
                            .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                            .foregroundStyle(.primary)

                        Text(selectedFrequency.title)
                            .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(themeManager.appPrimary)
            }
        }
    }

    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            sectionTitle(L10n.AddHabitPage.frequencySectionTitle)

            formRow(systemImage: SystemIconName.calendar) {
                VStack(alignment: .leading, spacing: Spacing.medium) {
                    Text(L10n.AddHabitPage.frequencySectionTitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                        .foregroundStyle(.primary)

                    Picker(L10n.AddHabitPage.frequencySectionTitle, selection: frequencyBinding) {
                        ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.title).tag(frequency)
                        }
                    }
                    .pickerStyle(.segmented)

                    if selectedFrequency == .custom {
                        customWeekdayPicker
                    }
                }
            }
        }
    }

    private var customWeekdayPicker: some View {
        HStack(spacing: Spacing.xSmall) {
            ForEach(customWeekdays, id: \.weekday) { item in
                customWeekdayButton(item)
            }
        }
        .padding(.top, Spacing.x3Small)
    }

    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            sectionTitle(L10n.AddHabitPage.reminderSectionTitle)

            formRow(systemImage: SystemIconName.bell) {
                VStack(alignment: .leading, spacing: Spacing.medium) {
                    Text(L10n.AddHabitPage.reminderSectionTitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                        .foregroundStyle(.primary)

                    Text(L10n.AddHabitPage.reminderSubtitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                        .foregroundStyle(.secondary)

                    HStack(spacing: Spacing.medium) {
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()

                        Spacer()

                        Button {
                            onReminderTimeAdd(HabitReminderTimeFormatter.storageTime(from: reminderTime))
                        } label: {
                            Image(systemName: SystemIconName.plus)
                                .font(.system(size: FontSize.medium, weight: .semibold))
                                .frame(width: Size.xLarge, height: Size.xLarge)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(themeManager.appPrimary)
                    }

                    if reminderTimes.isNotEmpty {
                        VStack(spacing: Spacing.xSmall) {
                            ForEach(reminderTimes, id: \.self) { time in
                                reminderRow(time)
                            }
                        }
                        .padding(.top, Spacing.x2Small)
                    }
                }
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.AppFont.rooneySansBold.size(FontSize.small))
            .foregroundStyle(themeManager.appPrimary)
            .tracking(1.2)
    }

    private func formRow<Content: View>(
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(alignment: .center, spacing: Spacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: FontSize.x4Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
                .frame(width: Size.x3Large, height: Size.x3Large)
                .background(themeManager.appPrimary.opacity(Opacity.quiet))
                .clipShape(Circle())

            content()
        }
        .padding(.horizontal, Spacing.xLarge)
        .padding(.vertical, Spacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appWhite)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xLarge))
    }

    private func iconButton(_ icon: String) -> some View {
        let isSelected = selectedIconName == icon

        return Button {
            onIconSelect(icon)
        } label: {
            Image(systemName: icon)
                .font(.system(size: FontSize.x4Large, weight: .medium))
                .foregroundStyle(isSelected ? .appWhite : themeManager.appPrimary)
                .frame(width: Size.x3Large, height: Size.x3Large)
                .background(isSelected ? themeManager.appPrimary : themeManager.appPrimary.opacity(Opacity.quiet))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private func customWeekdayButton(_ item: HabitWeekdayItem) -> some View {
        let isSelected = selectedCustomWeekdays.contains(item.weekday)

        return Button {
            onCustomWeekdayToggle(item.weekday)
        } label: {
            Text(item.title)
                .font(.AppFont.rooneySansBold.size(FontSize.medium))
                .foregroundStyle(isSelected ? .appWhite : themeManager.appPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xSmall)
                .background(isSelected ? themeManager.appPrimary : themeManager.appPrimary.opacity(Opacity.quiet))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func reminderRow(_ time: String) -> some View {
        HStack(spacing: Spacing.medium) {
            Text(HabitReminderTimeFormatter.displayTime(from: time))
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                .foregroundStyle(.primary)

            Spacer()

            Button {
                if let index = reminderTimes.firstIndex(of: time) {
                    onReminderTimeRemove(IndexSet(integer: index))
                }
            } label: {
                Image(systemName: SystemIconName.xmark)
                    .font(.system(size: FontSize.xSmall, weight: .bold))
                    .foregroundStyle(themeManager.appPrimary)
                    .frame(width: Size.medium, height: Size.medium)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.small)
        .background(themeManager.appPrimary.opacity(Opacity.quiet))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
    }

    private var commitmentDaysBinding: Binding<Int> {
        Binding(
            get: { commitmentDays },
            set: { newValue in
                if newValue > commitmentDays {
                    onCommitmentDaysIncrement()
                } else if newValue < commitmentDays {
                    onCommitmentDaysDecrement()
                }
            }
        )
    }

    private var futureHabitBinding: Binding<Bool> {
        Binding(
            get: { isFutureHabit },
            set: { newValue in
                onFutureHabitChange(newValue)
            }
        )
    }

    private var frequencyBinding: Binding<HabitFrequency> {
        Binding(
            get: { selectedFrequency },
            set: { newValue in
                onFrequencySelect(newValue)
            }
        )
    }


    private var selectedDisplayIconName: String {
        selectedIconName.isEmpty ? SystemIconName.checkmark : selectedIconName
    }

    private var customWeekdays: [HabitWeekdayItem] {
        HabitFormConstants.weekdays
    }

    private var iconNames: [String] {
        HabitFormConstants.iconNames
    }
}
