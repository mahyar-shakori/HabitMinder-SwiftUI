//
//  SettingView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject private var settingViewModel: SettingViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isEditingUserName = false
    @State private var isShowingColorPicker = false
    
    init(settingViewModel: SettingViewModel) {
        self.settingViewModel = settingViewModel
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
            .font(.AppFont.rooneySansBold.size(28))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
            .padding(.horizontal, 24)
    }
    
    private var settingCustomize: some View {
        VStack(alignment: .leading, spacing: 24) {
            userNameSection
            colorSection
        }
        .padding(.top, 8)
        .padding()
    }
    
    private var userNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStrings.SettingPage.userName)
                .font(.AppFont.rooneySansRegular.size(18))
                .foregroundColor(.gray)
            userNameField
        }
    }
    
    private var userNameField: some View {
        Button {
            isEditingUserName = true
        } label: {
            userNameButtonContent
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appWhite)
                )
        }
        .buttonStyle(PlainButtonStyle())
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
                .font(.AppFont.rooneySansRegular.size(18))
            
            Spacer()
            
            Image(systemName: AppIconName.chevronDown)
                .foregroundColor(.gray)
        }
    }
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStrings.SettingPage.appColor)
                .font(.AppFont.rooneySansRegular.size(18))
                .foregroundColor(.gray)
            colorPickerField
        }
    }
    
    private var colorPickerField: some View {
        Button {
            isShowingColorPicker = true
        } label: {
            colorPickerButtonContent
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appWhite)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowingColorPicker) {
            ColorPickerView(isPresented: $isShowingColorPicker)
        }
    }
    
    private var colorPickerButtonContent: some View {
        HStack {
            Text(LocalizedStrings.SettingPage.setColor)
                .font(.AppFont.rooneySansRegular.size(18))
            
            Spacer()
            
            Circle()
                .fill(themeManager.appPrimary)
                .frame(width: 24, height: 24)
            
            Image(systemName: AppIconName.chevronDown)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    let fakeCoordinator = SettingCoordinator(dismiss: {
    })
    let userDefaultsContainer = DIContainer.UserDefaults()
    let themeManager = ThemeManager()
    let viewModel = SettingViewModel(
        coordinator: fakeCoordinator,
        userNameStorage: userDefaultsContainer.userNameStorage
    )
    SettingView(settingViewModel: viewModel)
        .environmentObject(themeManager)
}
