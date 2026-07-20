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
                L10n.SettingPage.enterNewUserName,
                text: $tempUserName
            )
            .font(.AppFont.rooneySansRegular.size(FontSize.x2Large))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(.appWhite)
            )
            .padding(.horizontal, Spacing.xLarge)
            .focused($isFocused)
            .submitLabel(.done)
            
            Spacer()
        }
        .padding(.top, Spacing.xLarge)
        .background(.appGray)
    }
    
    private var toolbarTitle: some View {
        Text(L10n.SettingPage.editUserName)
            .font(.AppFont.rooneySansBold.size(FontSize.x4Large))
    }
   
    private var toolbarSaveButton: some View {
        ToolbarTextButton(L10n.Shared.saveButton, weight: .bold) {
            settingViewModel.setUserName(tempUserName)
            isPresented = false
        }
    }
   
    private var toolbarCancelButton: some View {
        ToolbarTextButton(L10n.Shared.cancelButton) {
            isPresented = false
        }
    }
}


#Preview {
    let isPresented = Binding<Bool>.constant(false)
    let currentName = "test"
    UserNameEditorView(isPresented: isPresented, currentName: currentName)
}
