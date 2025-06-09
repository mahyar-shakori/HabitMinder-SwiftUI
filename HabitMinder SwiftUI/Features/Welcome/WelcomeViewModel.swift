//
//  WelcomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class WelcomeViewModel: ObservableObject {
    @Published private(set) var uiState = WelcomeUIState()
    
    private let networkAPI: DataFetcher
    private let userDefaultsStorage: UserDefaultsStorage<UserDefaultKeys, String>
    private let coordinator: WelcomeCoordinating

    init(
        coordinator: WelcomeCoordinating,
        networkAPI: DataFetcher = NetworkAPI(configuration: .init(timeoutInterval: 3)),
        userDefaultsStorage: UserDefaultsStorage<UserDefaultKeys, String> = UserDefaultsStorage(key: .userName)
    ) {
        self.coordinator = coordinator
        self.networkAPI = networkAPI
        self.userDefaultsStorage = userDefaultsStorage
    }
  
    func loadUserName() {
        let storedName = userDefaultsStorage.fetch()
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
        try await networkAPI.fetchData(from: AuthEndpoint.getQuote)
    }
    
    private func handleQuoteSuccess(_ quotes: [QuoteResponse]) {
        let rawQuote = quotes.first?.quote ?? ""
        let trimmedQuote = rawQuote.count > 100
        ? LocalizedStrings.WelcomePage.defaultQuote
        : rawQuote
        
        coordinator.goToHome(trimmedQuote)
        
        uiState.quote = trimmedQuote
        uiState.isFetchSuccessful = true
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
