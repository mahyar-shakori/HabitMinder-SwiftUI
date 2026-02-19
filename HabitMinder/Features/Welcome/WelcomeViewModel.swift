//
//  WelcomeViewModel.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class WelcomeViewModel: ObservableObject {
    @Published private(set) var uiState = WelcomeUIState()
    
    private let fetchQuoteUseCase: APIFetching
    private let userDefaultsStorage: UserDefaultsStoring
    private let coordinator: WelcomeCoordinating

    init(
        coordinator: WelcomeCoordinating,
        fetchQuoteUseCase: APIFetching,
        userDefaultsStorage: UserDefaultsStoring
    ) {
        self.coordinator = coordinator
        self.fetchQuoteUseCase = fetchQuoteUseCase
        self.userDefaultsStorage = userDefaultsStorage
        
        loadUserName()
    }
  
    func loadUserName() {
        let storedName: String? = userDefaultsStorage.fetch(for: UserDefaultKeys.userName)
        uiState.userName = formattedWelcomeName(from: storedName)
    }
  
//    @MainActor
    func fetchData() async {
        do {
            let quotes = try await fetchQuotes()
            
            await MainActor.run {
                handleQuoteSuccess(quotes)
                        }
            
//            let quoteResponse = try await fetchQuoteUseCase.execute()
//            handleQuoteSuccess([quoteResponse])
        } catch {
                        await MainActor.run {
            
            handleQuoteFailure(error)
        }
        }
    }
    
    private func fetchQuotes() async throws -> [QuoteResponse] {
        try await fetchQuoteUseCase.fetchData(from: AuthEndpoints.getQuote)
    }
    
//    func fetchData() async {
//        do {
//            // background
//            let quoteResponse = try await fetchQuoteUseCase.execute()
//            
//            // back to main thread
//            await MainActor.run {
//                handleQuoteSuccess([quoteResponse])
//            }
//        } catch {
//            await MainActor.run {
//                handleQuoteFailure(error)
//            }
//        }
//    }
   
    private func handleQuoteSuccess(_ quotes: [QuoteResponse]) {
        let quote = quotes.first?.quote ?? ""

        coordinator.goToHome(quote)
        uiState.errorMessage = nil
    }
    
    private func handleQuoteFailure(_ error: Error) {
        uiState.errorMessage = error.localizedDescription
    }
    
    func goToHomePage() {
        coordinator.goToHome("")
    }
    
    private func formattedWelcomeName(from userName: String?) -> String {
        return userName.map { LocalizedStrings.WelcomePage.welcome + $0 }
        ?? LocalizedStrings.WelcomePage.guest
    }
}
