//
//  FetchQuoteUseCase.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

import Foundation

struct FetchQuoteUseCase {
    private let repository: QuoteRepositoryProtocol
    
    init(repository: QuoteRepositoryProtocol = QuoteRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> QuoteResponse {
        try await repository.fetchQuote()
    }
}
