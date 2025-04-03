//
//  WelcomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var welcomeViewModel = WelcomeViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var showAlert = false
    @State private var quote: String = ""
    
    var body: some View {
        VStack {
            welcomeImage
            welcomeText
            progressView
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: setupViewModel)
        .onChange(of: welcomeViewModel.errorMessage) {
            showAlert = welcomeViewModel.errorMessage != nil
        }
        .alert(LocalizedStrings.Alert.Network.title, isPresented: $showAlert) {
            Button(LocalizedStrings.Shared.okButton, role: .cancel) {
                coordinator.push(.home(quote: ""))
            }
        } message: {
            Text(welcomeViewModel.errorMessage ?? LocalizedStrings.Alert.Network.defaultError)
        }
    }
    
    private func setupViewModel() {
        welcomeViewModel.setQuoteDelegate(coordinator)
        welcomeViewModel.loadUserName()
        welcomeViewModel.fetchQuote()
    }
    
    private var welcomeImage: some View {
        Image(.welcome)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 128)
    }
    
    private var welcomeText: some View {
        Text(welcomeViewModel.name)
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
    WelcomeView()
        .environmentObject(Coordinator())
}
