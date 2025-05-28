//
//  WelcomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var welcomeViewModel: WelcomeViewModel
    @EnvironmentObject private var coordinator: WelcomeViewCoordinator
    @State private var showAlert = false
    
    init(welcomeViewModel: WelcomeViewModel) {
        _welcomeViewModel = StateObject(wrappedValue: welcomeViewModel)
    }
   
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: setupViewModel)
            .onChange(of: welcomeViewModel.uiState.errorMessage) {
                showAlert = welcomeViewModel.uiState.errorMessage != nil
            }
            .alert(LocalizedStrings.Alert.Network.title, isPresented: $showAlert) {
                Button(LocalizedStrings.Shared.okButton) {
                    coordinator.goToHome(quote: "")
                }
            } message: {
                Text(welcomeViewModel.uiState.errorMessage ?? LocalizedStrings.Alert.Network.defaultError)
            }
    }
    
    private var content: some View {
        VStack {
            Spacer()
            
            welcomeImage
            welcomeText
            progressView
            
            Spacer()
        }
    }
    
    private func setupViewModel() {
        welcomeViewModel.setQuoteDelegate(coordinator)
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
            .tint(.secondary)
            .padding(.top, 32)
    }
}

#Preview {
    let mockNavigate: (AppRoute, PresentationStyle) -> Void = { route, style in
        print("Preview navigation to \(route) with style \(style)")
    }
    
    return WelcomeView(welcomeViewModel: WelcomeViewModel())
        .environmentObject(WelcomeViewCoordinator(navigate: mockNavigate))
}
