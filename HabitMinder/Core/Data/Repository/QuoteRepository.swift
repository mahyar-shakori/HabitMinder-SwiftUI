//
//  QuoteRepository.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

import Foundation

final class QuoteRepository: QuoteRepositoryProtocol {
    private let apiService: APIFetching
    
    init(apiService: APIFetching = APIService()) {
        self.apiService = apiService
    }
    
    func fetchQuote() async throws -> QuoteResponse {
        try await apiService.fetchData(from: AuthEndpoints.getQuote)
    }
}
