//
//  UserNameEditorView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct UserNameEditorView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var settingViewModel: SettingViewModel
    @State private var tempUserName: String
    @FocusState private var isFocused: Bool
    
    init(isPresented: Binding<Bool>, currentName: String) {
        self._isPresented = isPresented
        self._tempUserName = State(initialValue: currentName)
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
            TextField(LocalizedStrings.SettingPage.enterNewUserName, text: $tempUserName)
                .font(.AppFont.rooneySansRegular.size(16))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.appWhite)
                )
                .padding(.horizontal, 16)
                .focused($isFocused)
                .submitLabel(.done)
            
            Spacer()
        }
        .padding(.top, 16)
        .background(.appGray)
    }
    
    private var toolbarTitle: some View {
        Text(LocalizedStrings.SettingPage.editUserName)
            .font(.AppFont.rooneySansBold.size(18))
    }
    
    private var toolbarSaveButton: some View {
        Button {
            settingViewModel.userName = tempUserName
            settingViewModel.changeUserName()
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
                .font(.AppFont.rooneySansBold.size(18))
        }
    }
    
    private var toolbarCancelButton: some View {
        Button {
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.cancelButton)
                .font(.AppFont.rooneySansRegular.size(18))
        }
    }
}

#Preview {
    UserNameEditorView(isPresented: .constant(false), currentName: "")
}
