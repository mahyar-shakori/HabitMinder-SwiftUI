//
//  QuoteRepository.swift
//  HabitMinder
//
//  Created by Mahyar on 19/07/2026.
//

import Foundation

final class QuoteRepository: QuoteRepositoryProtocol {
    private let apiService: APIFetching
    
    init(apiService: APIFetching) {
        self.apiService = apiService
    }

    func fetchQuote() async throws -> [Quote] {
        let request = try QuoteEndpoint.quote.asURLRequest()
        return try await apiService.fetchData(from: request)
    }
}
