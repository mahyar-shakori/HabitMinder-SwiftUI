//
//  WelcomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var welcomeViewModel: WelcomeViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showAlert = false
    
    init(welcomeViewModel: WelcomeViewModel) {
        self.welcomeViewModel = welcomeViewModel
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: setupViewModel)
            .onChange(of: welcomeViewModel.uiState.errorMessage) { _, newError in
                showAlert = (newError != nil)
            }
            .alert(LocalizedStrings.Alert.Network.title, isPresented: $showAlert) {
                Button(LocalizedStrings.Shared.okButton) {
                    welcomeViewModel.goToHomePage()
                }
            } message: {
                Text(welcomeViewModel.uiState.errorMessage ?? LocalizedStrings.Alert.Network.unknownError)
            }
    }
    
    private var content: some View {
        ZStack {
            Color.appGray
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                welcomeImage
                welcomeText
                progressView
                Spacer()
            }
        }
    }
    
    private func setupViewModel() {
        welcomeViewModel.loadUserName()
        Task {
            await welcomeViewModel.fetchData()
        }
    }
    
    private var welcomeImage: some View {
        Image(.welcome)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 128)
    }
    
    private var welcomeText: some View {
        Text(welcomeViewModel.uiState.userName)
            .font(.AppFont.rooneySansBold.size(23))
            .padding(.top, 64)
    }
    
    private var progressView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .tint(themeManager.appPrimary)
            .padding(.top, 32)
    }
}

#Preview {
    let fakeCoordinator = WelcomeCoordinator(navigate: { _ in
    })
    let userDefaultsContainer = DIContainer.UserDefaults()
    let themeManager = ThemeManager()
    let viewModel = WelcomeViewModel(
        coordinator: fakeCoordinator,
        userNameStorage: userDefaultsContainer.userNameStorage
    )
    WelcomeView(welcomeViewModel: viewModel)
        .environmentObject(themeManager)
}
