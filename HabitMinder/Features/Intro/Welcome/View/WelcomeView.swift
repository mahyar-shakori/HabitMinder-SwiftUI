//
//  WelcomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    private var welcomeViewModel: WelcomeViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showAlert = false
    
    init(welcomeViewModel: WelcomeViewModel) {
        self.welcomeViewModel = welcomeViewModel
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    await welcomeViewModel.fetchData()
                }
            }
            .onChange(of: welcomeViewModel.errorMessage) { _, newError in
                showAlert = (newError != nil)
            }
            .alert(LocalizedStrings.Alert.Network.title, isPresented: $showAlert) {
                Button(LocalizedStrings.Shared.okButton) {
                    welcomeViewModel.goToHomePage()
                }
            } message: {
                Text(welcomeViewModel.errorMessage ?? LocalizedStrings.Alert.Network.unknownError)
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
    
    private var welcomeImage: some View {
        Image(.welcome)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, Spacing.x3Large)
    }
    
    private var welcomeText: some View {
        Text(welcomeViewModel.userName)
            .font(Fonts.titleLarge)
            .padding(.top, Spacing.x2Large)
    }
    
    private var progressView: some View {
        ProgressView()
            .scaleEffect(Scale.medium)
            .tint(themeManager.appPrimary)
            .padding(.top, Spacing.xLarge)
    }
}

#Preview {
    let fakeCoordinator = WelcomeCoordinator(navigate: { _ in
    })
    let userDefaults = UserDefaultsStorage()
    let themeManager = ThemeManager()
    let repository = QuoteRepository(apiService: APIService())
    let viewModel = WelcomeViewModel(
        coordinator: fakeCoordinator,
        repository: repository,
        userDefaultsStorage: userDefaults
    )
    WelcomeView(welcomeViewModel: viewModel)
        .environmentObject(themeManager)
}
