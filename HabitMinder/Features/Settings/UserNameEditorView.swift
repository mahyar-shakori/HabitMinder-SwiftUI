//
//  UserNameEditorView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct UserNameEditorView: View {
    @EnvironmentObject private var settingViewModel: SettingViewModel
    @FocusState private var isFocused: Bool
    @Binding private var isPresented: Bool
    @State private var tempUserName: String
    
    init(
        isPresented: Binding<Bool>,
        currentName: String
    ) {
        self._isPresented = isPresented
        self.tempUserName = currentName
    }
    
    var body: some View {
        NavigationView {
            userNameField
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        toolbarTitle
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        toolbarSaveButton
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        toolbarCancelButton
                    }
                }
        }
    }
    
    private var userNameField: some View {
        VStack {
            TextField(
                LocalizedStrings.SettingPage.enterNewUserName,
                text: $tempUserName
            )
            .font(.AppFont.rooneySansRegular.size(Metrics.textFieldFontSize))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Metrics.textFieldCornerRadius)
                    .fill(.appWhite)
            )
            .padding(.horizontal, Metrics.horizontalPadding)
            .focused($isFocused)
            .submitLabel(.done)
            
            Spacer()
        }
        .padding(.top, Metrics.topPadding)
        .background(.appGray)
    }
    
    private var toolbarTitle: some View {
        Text(LocalizedStrings.SettingPage.editUserName)
            .font(.AppFont.rooneySansBold.size(Metrics.toolbarTitleFontSize))
    }
   
    private var toolbarSaveButton: some View {
        ToolbarTextButton(LocalizedStrings.Shared.saveButton, weight: .bold) {
            settingViewModel.setUserName(tempUserName)
            isPresented = false
        }
    }
   
    private var toolbarCancelButton: some View {
        ToolbarTextButton(LocalizedStrings.Shared.cancelButton) {
            isPresented = false
        }
    }
}

private enum Metrics {
    static let textFieldFontSize: CGFloat = 16
    static let textFieldCornerRadius: CGFloat = 12
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 16
    static let toolbarTitleFontSize: CGFloat = 18
}

private enum PreviewData {
    static let currentName = LocalizedStrings.SettingPage.userName
}

#Preview {
    let isPresented = Binding<Bool>.constant(false)
    let currentName = PreviewData.currentName
    UserNameEditorView(isPresented: isPresented, currentName: currentName)
}
