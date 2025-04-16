//
//  WelcomeView.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 01/04/2025.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var welcomeViewModel: WelcomeViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: setupViewModel)
            .alert(LocalizedStrings.Alert.Network.title, isPresented: $welcomeViewModel.showAlert) {
                Button(LocalizedStrings.Shared.okButton, role: .cancel) {
                    coordinator.push(.home(quote: ""))
                }
            } message: {
                Text(welcomeViewModel.errorMessage ?? LocalizedStrings.Alert.Network.defaultError)
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
        welcomeViewModel.fetchData()
    }
    
    private var welcomeImage: some View {
        Image(.welcome)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 128)
    }
    
    private var welcomeText: some View {
        Text(welcomeViewModel.userName)
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
    WelcomeView(welcomeViewModel: WelcomeViewModel())
        .environmentObject(Coordinator())
}
