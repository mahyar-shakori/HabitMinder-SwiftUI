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
            .alert(L10n.Alert.Network.title, isPresented: $showAlert) {
                Button(L10n.Shared.okButton) {
                    welcomeViewModel.goToHomePage()
                }
            } message: {
                Text(welcomeViewModel.errorMessage ?? L10n.Alert.Network.unknownError)
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
            .padding(.horizontal, Spacing.x9Large)
    }
    
    private var welcomeText: some View {
        Text(welcomeViewModel.userName)
            .font(.AppFont.rooneySansBold.size(FontSize.x8Large))
            .padding(.top, Spacing.x8Large)
    }
    
    private var progressView: some View {
        ProgressView()
            .scaleEffect(Scale.medium)
            .tint(themeManager.appPrimary)
            .padding(.top, Spacing.xLarge)
    }
}

#Preview {
    let dependencies = AppDependencies()
    let introDependencies = dependencies.destinationDependencies.intro
    let fakeCoordinator = WelcomeCoordinator(navigate: { _ in
    })
    let viewModel = WelcomeViewModel(
        coordinator: fakeCoordinator,
        repository: introDependencies.quoteRepository,
        userDefaultsStorage: introDependencies.userDefaultsStorage
    )
    WelcomeView(welcomeViewModel: viewModel)
        .environmentObject(dependencies.themeManager)
}
