//
//  LanguagePickerView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 29/05/2025.
//

import SwiftUI

struct LanguagePickerView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @Binding private var isPresented: Bool
    @State private var tempSelectedLanguage: AppLanguage
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        _tempSelectedLanguage = State(initialValue: LanguageManager.shared.selectedLanguage)
    }
    
    var body: some View {
        content
            .onAppear {
                tempSelectedLanguage = languageManager.selectedLanguage
            }
    }
    
    private var content: some View {
        NavigationView {
            languageList
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
    
    private var languageList: some View {
        List {
            ForEach(AppLanguage.allCases) { language in
                Button {
                    tempSelectedLanguage = language
                } label: {
                    HStack {
                        Text(language.displayName)
                           .font(.AppFont.rooneySansRegular.size(18))

                        if language == tempSelectedLanguage {
                            Spacer()
                            Image(systemName: AppIconName.checkmark)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
    }
    
    private var toolbarTitle: some View {
        Text(LocalizedStrings.SettingPage.selectLanguage)
            .font(.AppFont.rooneySansBold.size(18))
    }
    
    private var toolbarSaveButton: some View {
        Button {
            languageManager.selectedLanguage = tempSelectedLanguage
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
    let isPresented = Binding<Bool>.constant(false)
    LanguagePickerView(isPresented: isPresented)
        .environmentObject(LanguageManager.shared)
}
