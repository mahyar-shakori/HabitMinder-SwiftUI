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
        CustomButton(style: CustomButtonStylePreset.default(
            font: .AppFont.rooneySansBold.size(18),
            tintColor: .blue
        )) {
            settingViewModel.setUserName(tempUserName)
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.saveButton)
        }
    }
   
    private var toolbarCancelButton: some View {
        CustomButton(style: CustomButtonStylePreset.default(
            font: .AppFont.rooneySansRegular.size(18),
            tintColor: .blue
        )) {
            isPresented = false
        } label: {
            Text(LocalizedStrings.Shared.cancelButton)
        }
    }
}

#Preview {
    let isPresented = Binding<Bool>.constant(false)
    let currentName = "Sample Name"
    UserNameEditorView(isPresented: isPresented, currentName: currentName)
}
