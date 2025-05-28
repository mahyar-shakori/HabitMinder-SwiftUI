//
//  SetLanguageView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct SetLanguageView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var coordinator: SetLanguageViewCoordinator
    
    var body: some View {
        VStack(spacing: 24) {
            titleText
            selectedLanguageButton
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.setLanguagePage.title)
            .font(.AppFont.rooneySansBold.size(20))
    }
    
    private var selectedLanguageButton: some View {
        ForEach(AppLanguage.allCases) { language in
            Button(action: {
                languageManager.selectedLanguage = language
                coordinator.goToIntro()
            }) {
                Text(language.displayName)
                    .font(.AppFont.rooneySansBold.size(16))
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule()
                            .fill(.appPrimary))
                    .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    SetLanguageView()
}
