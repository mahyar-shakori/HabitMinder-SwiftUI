//
//  SettingView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var settingViewModel: SettingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditingUserName = false
    @State private var isShowingColorPicker = false
    
    init(settingViewModel: SettingViewModel) {
        _settingViewModel = StateObject(wrappedValue: settingViewModel)
    }
    
    var body: some View {
        VStack {
            titleText
            
            ScrollView {
                settingCustomize
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .background(.appGray)
        .onAppear() {
            settingViewModel.loadUserName()
        }
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.SettingPage.title)
            .font(.AppFont.rooneySansBold.size(Metrics.titleFontSize))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Metrics.titleTopPadding)
            .padding(.horizontal, Metrics.horizontalPadding)
    }
    
    private var settingCustomize: some View {
        VStack(alignment: .leading, spacing: Metrics.sectionSpacing) {
            userNameSection
            colorSection
        }
        .padding(.top, Metrics.contentTopPadding)
        .padding()
    }
    
    private var userNameSection: some View {
        VStack(alignment: .leading, spacing: Metrics.fieldSpacing) {
            Text(LocalizedStrings.SettingPage.userName)
                .font(.AppFont.rooneySansRegular.size(Metrics.labelFontSize))
                .foregroundColor(.gray)
            userNameField
        }
    }
    
    private var userNameField: some View {
        SettingsRowButton {
            isEditingUserName = true
        } content: {
            userNameButtonContent
        }
        .sheet(isPresented: $isEditingUserName) {
            UserNameEditorView(
                isPresented: $isEditingUserName,
                currentName: settingViewModel.userName
            )
            .environmentObject(settingViewModel)
        }
    }
    
    private var userNameButtonContent: some View {
        HStack {
            Text(settingViewModel.userName)
            Spacer()
            Image(systemName: AppIconName.chevronDown)
                .foregroundColor(.gray)
        }
    }
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: Metrics.fieldSpacing) {
            Text(LocalizedStrings.SettingPage.appColor)
                .font(.AppFont.rooneySansRegular.size(Metrics.labelFontSize))
                .foregroundColor(.gray)
            colorPickerField
        }
    }
    
    private var colorPickerField: some View {
        SettingsRowButton {
            isShowingColorPicker = true
        } content: {
            colorPickerButtonContent
        }
        .sheet(isPresented: $isShowingColorPicker) {
            ColorPickerView(isPresented: $isShowingColorPicker)
        }
    }
    
    private var colorPickerButtonContent: some View {
        HStack {
            Text(LocalizedStrings.SettingPage.setColor)
            Spacer()
            
            Circle()
                .fill(themeManager.appPrimary)
                .frame(width: Metrics.colorPreviewSize, height: Metrics.colorPreviewSize)
            
            Image(systemName: AppIconName.chevronDown)
                .foregroundColor(.gray)
        }
    }
}

private enum Metrics {
    static let titleFontSize: CGFloat = 28
    static let titleTopPadding: CGFloat = 32
    static let horizontalPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 24
    static let fieldSpacing: CGFloat = 8
    static let contentTopPadding: CGFloat = 8
    static let labelFontSize: CGFloat = 18
    static let colorPreviewSize: CGFloat = 24
}

#Preview {
    let dependencies = AppDependencies()
    let settingsDependencies = dependencies.destinationDependencies.main.settings
    let fakeCoordinator = SettingCoordinator(dismiss: {
    })
    let viewModel = SettingViewModel(
        coordinator: fakeCoordinator,
        userDefaultsStorage: settingsDependencies.userDefaultsStorage
    )
    SettingView(settingViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
