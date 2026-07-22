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
            return currentWindowColorScheme ?? colorScheme
        }
    }

    private var currentWindowColorScheme: ColorScheme? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .traitCollection
            .userInterfaceStyle
            .colorScheme
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.x5Large) {
                pageIntro
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

    private var pageIntro: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(L10n.SettingPage.appThemeIntroTitle)
                .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
                .foregroundStyle(.primary)

            Text(L10n.SettingPage.appThemeIntroDescription)
                .font(.AppFont.rooneySansRegular.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, Spacing.xSmall)
    }

    private var appearanceSection: some View {
        settingsSection(title: L10n.SettingPage.appearanceSection) {
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
                .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
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
        settingsSection(title: L10n.SettingPage.accentColorSection) {
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
                rowIcon(SystemIconName.paintpalette)

                VStack(alignment: .leading, spacing: Spacing.x3Small) {
                    Text(L10n.SettingPage.customColor)
                        .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
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
        Button {
            selectedColor = .appPrimary
            themeManager.resetAppColorToDefault()
        } label: {
            HStack(spacing: Spacing.large) {
                rowIcon(SystemIconName.arrowCounterclockwise)

                VStack(alignment: .leading, spacing: Spacing.x3Small) {
                    Text(L10n.SettingPage.defaultColor)
                        .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
                        .foregroundStyle(.primary)

                    Text(L10n.SettingPage.defaultColorSubtitle)
                        .font(.AppFont.rooneySansRegular.size(FontSize.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: Size.medium, height: Size.medium)
            }
            .padding(.horizontal, Spacing.large)
            .padding(.vertical, Spacing.large)
        }
        .buttonStyle(.plain)
    }

    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(title.uppercased())
                .font(.AppFont.rooneySansBold.size(FontSize.x3Large))
                .foregroundStyle(.secondary)
                .padding(.horizontal, Spacing.large)

            content()
        }
    }

    private func rowIcon(_ iconName: String) -> some View {
        ZStack {
            Circle()
                .fill(themeManager.appSecondary.opacity(Opacity.badgeBackground))

            Image(systemName: iconName)
                .font(.system(size: FontSize.x5Large, weight: .medium))
                .foregroundStyle(themeManager.appPrimary)
        }
        .frame(width: Size.x2Large, height: Size.x2Large)
    }
}

private extension UIUserInterfaceStyle {
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .unspecified:
            return nil
        @unknown default:
            return nil
        }
    }
}

#Preview {
    let dependencies = AppDependencies()
    NavigationStack {
        ThemeView()
            .environmentObject(dependencies.themeManager)
    }
}
