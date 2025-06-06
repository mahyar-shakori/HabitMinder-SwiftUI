//
//  SetLanguageView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 28/05/2025.
//

import SwiftUI

struct SetLanguageView: View {
    @ObservedObject private var setLanguageViewModel: SetLanguageViewModel
    
    init(setLanguageViewModel: SetLanguageViewModel) {
        self.setLanguageViewModel = setLanguageViewModel
    }

    var body: some View {
        ZStack {
            Color(.appGray)
                .ignoresSafeArea()
            
            VStack() {
                Spacer()
                
                titleText
                selectedLanguageButton
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var titleText: some View {
        Text(LocalizedStrings.setLanguagePage.title)
            .font(.AppFont.rooneySansBold.size(20))
            .padding(.bottom, 32)
    }
    
    private var selectedLanguageButton: some View {
        ForEach(AppLanguage.allCases) { language in
            Button {
                setLanguageViewModel.selectLanguage(language)
                setLanguageViewModel.goToIntroPage()
            } label: {
                VStack {
                    Image(language.displayImage)
                    
                    Text(language.displayName)
                        .font(.AppFont.rooneySansBold.size(16))
                        .tint(.primary)
                }
                .padding()
            }
        }
    }
}

#Preview {
    let fakeCoordinator = SetLanguageCoordinator(navigate: { _, _ in
    })
    let viewModel = SetLanguageViewModel(
        coordinator: fakeCoordinator,
        languageManager: LanguageManager.shared
    )
    SetLanguageView(setLanguageViewModel: viewModel)
}
