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
        Text(L10n.SettingPage.title)
            .font(.AppFont.rooneySansBold.size(FontSize.x9Large))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.x7Large)
            .padding(.horizontal, Spacing.x5Large)
    }
    
    private var settingCustomize: some View {
        VStack(alignment: .leading, spacing: Spacing.x5Large) {
            userNameSection
            colorSection
        }
        .padding(.top, Spacing.xSmall)
        .padding()
    }
    
    private var userNameSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(L10n.SettingPage.userName)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
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
            Image(systemName: SystemIconName.chevronDown)
                .foregroundColor(.gray)
        }
    }
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(L10n.SettingPage.appColor)
                .font(.AppFont.rooneySansRegular.size(FontSize.x4Large))
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
            Text(L10n.SettingPage.setColor)
            Spacer()
            
            Circle()
                .fill(themeManager.appPrimary)
                .frame(width: Size.medium, height: Size.medium)
            
            Image(systemName: SystemIconName.chevronDown)
                .foregroundColor(.gray)
        }
    }
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
