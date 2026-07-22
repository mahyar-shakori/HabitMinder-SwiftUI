//
//  ThemeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedColor: Color = .appPrimary

    private var activePreferredColorScheme: ColorScheme? {
        switch themeManager.appearanceMode {
        case .light, .dark:
            return themeManager.preferredColorScheme
        case .system:
            return ColorScheme.currentWindow ?? colorScheme
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.x5Large) {
                PageIntroView(
                    title: L10n.SettingPage.appThemeIntroTitle,
                    description: L10n.SettingPage.appThemeIntroDescription
                )
                appearanceSection
                accentColorSection
            }
            .padding(.horizontal, Spacing.x4Large)
            .padding(.top, Spacing.x5Large)
            .padding(.bottom, Spacing.x5Large)
        }
        .scrollIndicators(.hidden)
        .background(.appGray)
        .navigationTitle(L10n.SettingPage.appTheme)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(activePreferredColorScheme)
        .onAppear {
            selectedColor = themeManager.appPrimary
        }
        .onChange(of: selectedColor) { _, newColor in
            themeManager.appPrimary = newColor
        }
    }

    private var appearanceSection: some View {
        SettingsSection(title: L10n.SettingPage.appearanceSection, style: .primary) {
            VStack(spacing: Spacing.none) {
                ForEach(AppAppearanceMode.allCases, id: \.self) { mode in
                    appearanceRow(for: mode)

                    if mode != AppAppearanceMode.allCases.last {
                        Divider()
                            .padding(.leading, Size.x3Large + Spacing.x3Large)
                    }
                }
            }
            .background(.appWhite)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
        }
    }

    private func appearanceRow(for mode: AppAppearanceMode) -> some View {
        HStack(spacing: Spacing.large) {
            Text(mode.title)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                .foregroundStyle(.primary)

            Spacer()

            Button {
                themeManager.appearanceMode = mode
            } label: {
                Image(systemName: themeManager.appearanceMode == mode ? SystemIconName.checkmarkCircleFill : SystemIconName.circle)
                    .font(.system(size: FontSize.x7Large, weight: .semibold))
                    .foregroundStyle(themeManager.appearanceMode == mode ? themeManager.appPrimary : .secondary.opacity(Opacity.subtleBorder))
                    .frame(width: Size.x2Large + Spacing.xSmall, height: Size.x2Large + Spacing.xSmall)
            }
            .buttonStyle(.plain)
            .contentShape(Circle())
            .accessibilityLabel(mode.title)
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
    }

    private var accentColorSection: some View {
        SettingsSection(title: L10n.SettingPage.accentColorSection, style: .primary) {
            VStack(spacing: Spacing.none) {
                colorPickerRow

                Divider()
                    .padding(.leading, Size.x3Large + Spacing.x3Large)

                defaultColorRow
            }
            .background(.appWhite)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
        }
    }

    private var colorPickerRow: some View {
        ColorPicker(selection: $selectedColor, supportsOpacity: false) {
            HStack(spacing: Spacing.large) {
                SettingsRowIcon(iconName: SystemIconName.paintpalette)

                VStack(alignment: .leading, spacing: Spacing.x3Small) {
                    Text(L10n.SettingPage.customColor)
                        .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
                        .foregroundStyle(.primary)

                    Text(L10n.SettingPage.customColorSubtitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .tint(themeManager.appPrimary)
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.large)
    }

    private var defaultColorRow: some View {
        SettingsActionRow(
            iconName: SystemIconName.arrowCounterclockwise,
            title: L10n.SettingPage.defaultColor,
            subtitle: L10n.SettingPage.defaultColorSubtitle,
            isTitleBold: false,
            action: resetDefaultColor
        ) {
            Circle()
                .fill(Color.appPrimary)
                .frame(width: Size.medium, height: Size.medium)
        }
    }

    private func resetDefaultColor() {
        selectedColor = .appPrimary
        themeManager.resetAppColorToDefault()
    }
}


#Preview {
    let dependencies = AppDependencies()
    NavigationStack {
        ThemeView()
            .environmentObject(dependencies.themeManager)
    }
}
