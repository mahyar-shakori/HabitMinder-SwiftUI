//
//  SetLanguageView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct SetLanguageView: View {
    @StateObject private var viewModel: SetLanguageViewModel
    @EnvironmentObject private var coordinator: SetLanguageViewCoordinator
    
    init(viewModel: SetLanguageViewModel = SetLanguageViewModel(
        languageManager: LanguageManager.shared,
    )) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            titleText
            selectedLanguageButton
            
            Spacer()
        }
        .padding()
        .background(.appGray)
        .navigationBarBackButtonHidden()
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.setLanguagePage.title)
            .font(.AppFont.rooneySansBold.size(20))
    }
    
    private var selectedLanguageButton: some View {
        ForEach(AppLanguage.allCases) { language in
            Button {
                viewModel.selectLanguage(language)
                coordinator.goToIntro()
            } label: {
                Text(language.displayName)
                    .font(.AppFont.rooneySansBold.size(16))
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule().fill(ThemeManager.shared.appPrimary)
                    )
                    .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    SetLanguageView()
}
