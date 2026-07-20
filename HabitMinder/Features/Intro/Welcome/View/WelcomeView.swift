//
//  WelcomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var welcomeViewModel: WelcomeViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showAlert = false
    
    init(welcomeViewModel: WelcomeViewModel) {
        _welcomeViewModel = State(initialValue: welcomeViewModel)
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
