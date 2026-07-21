//
//  WelcomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation
import Observation

@Observable
final class WelcomeViewModel {
    private(set) var errorMessage: String?
    private(set) var userName = ""
    private let userDefaultsStorage: UserDefaultsStoring
    private let coordinator: WelcomeCoordinating
    private let repository: QuoteRepositoryProtocol
    private var hasFetchedData = false
    
    init(
        coordinator: WelcomeCoordinating,
        repository: QuoteRepositoryProtocol,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.coordinator = coordinator
        self.repository = repository
        self.userDefaultsStorage = userDefaultsStorage
        
        loadUserName()
    }
    
    func loadUserName() {
        let storedName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.userName)
        userName = formattedWelcomeName(from: storedName)
    }
    
    @MainActor
    func fetchData() async {
        do {
            let quote = try await repository.fetchQuote()
            handleQuoteSuccess(quote)
        } catch {
            handleQuoteFailure(error)
        }
    }
    
    private func handleQuoteSuccess(_ quotes: [Quote]) {
        let quote = quotes.first?.quote ?? ""
        let author = quotes.first?.author ?? ""

        coordinator.goToHome(quote: quote, author: author)
        errorMessage = nil
    }
    
    private func handleQuoteFailure(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func goToHomePage() {
        coordinator.goToHome(quote: "", author: "")
    }
    
    private func formattedWelcomeName(from userName: String?) -> String {
        return userName.map { L10n.WelcomePage.welcome + $0 }
        ?? L10n.WelcomePage.guest
    }
}
