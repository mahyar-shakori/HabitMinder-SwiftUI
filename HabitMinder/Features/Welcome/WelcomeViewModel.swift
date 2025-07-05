//
//  WelcomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class WelcomeViewModel: ObservableObject {
    @Published private(set) var uiState = WelcomeUIState()
    
    private let apiFetching: APIFetching
    private let userDefaultsStorage: UserDefaultsStoring
    private let coordinator: WelcomeCoordinating

    init(
        coordinator: WelcomeCoordinating,
        apiFetching: APIFetching,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.coordinator = coordinator
        self.apiFetching = apiFetching
        self.userDefaultsStorage = userDefaultsStorage
    }
  
    func loadUserName() {
        let storedName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.userName)
        uiState.userName = formattedWelcomeName(from: storedName)
    }
  
    @MainActor
    func fetchData() async {
        do {
            let quotes = try await fetchQuotes()
            handleQuoteSuccess(quotes)
        } catch {
            handleQuoteFailure(error)
        }
    }
    
    private func fetchQuotes() async throws -> [QuoteResponse] {
        try await apiFetching.fetchData(from: AuthEndpoints.getQuote)
    }
    
    private func handleQuoteSuccess(_ quotes: [QuoteResponse]) {
        let rawQuote = quotes.first?.quote ?? ""

        coordinator.goToHome(rawQuote)
        uiState.errorMessage = nil
    }
    
    private func handleQuoteFailure(_ error: Error) {
        uiState.errorMessage = error.localizedDescription
    }
    
    func goToHomePage() {
        coordinator.goToHome("")
    }
    
    private func formattedWelcomeName(from userName: String?) -> String {
        userName.map { LocalizedStrings.WelcomePage.welcome + $0 }
        ?? LocalizedStrings.WelcomePage.guest
    }
}
