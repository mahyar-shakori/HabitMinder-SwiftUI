//
//  WelcomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

@MainActor
final class WelcomeViewModel: ObservableObject {
    @Published var name = ""
    @Published var errorMessage: String?
    @Published var isFetchSuccessful = false
    
    private let networkAPI: NetworkAPIProtocol
    private let userDefaultsStorage: UserDefaultsStorage<UserDefaultKeys, String>
    private weak var quoteDelegate: QuoteUpdatable?
    
    init(
        networkAPI: NetworkAPIProtocol = NetworkAPI(),
        userDefaultsStorage: UserDefaultsStorage<UserDefaultKeys, String> = UserDefaultsStorage(key: .userName),
        quoteDelegate: QuoteUpdatable? = nil
    ) {
        self.networkAPI = networkAPI
        self.userDefaultsStorage = userDefaultsStorage
        self.quoteDelegate = quoteDelegate
    }
    
    func setQuoteDelegate(_ delegate: QuoteUpdatable) {
        self.quoteDelegate = delegate
    }
    
    func loadUserName() {
        let storedName = userDefaultsStorage.fetch()
        name = formattedWelcomeName(from: storedName)
    }
    
    func fetchQuote() {
        Task {
            do {
                let quotes = try await fetchQuotes()
                handleQuoteSuccess(quotes)
            } catch {
                handleQuoteFailure(error)
            }
        }
    }
    
    private func fetchQuotes() async throws -> [QuoteResponse] {
        try await networkAPI.fetchData(
            from: AuthEndpoint.getQuote,
            decodeType: [QuoteResponse].self
        )
    }
    
    private func handleQuoteSuccess(_ quotes: [QuoteResponse]) {
        let quote = quotes.first?.quote ?? ""
        let trimmedQuote = quote.count > 100
        ? LocalizedStrings.WelcomePage.defaultQuote
        : quote
        
        quoteDelegate?.updateQuote(trimmedQuote)
        isFetchSuccessful = true
    }
    
    private func handleQuoteFailure(_ error: Error) {
        self.errorMessage = error.localizedDescription
    }
    
    private func formattedWelcomeName(from userName: String?) -> String {
        if let userName = userName {
            return LocalizedStrings.WelcomePage.welcome + userName
        } else {
            return LocalizedStrings.WelcomePage.guest
        }
    }
}
