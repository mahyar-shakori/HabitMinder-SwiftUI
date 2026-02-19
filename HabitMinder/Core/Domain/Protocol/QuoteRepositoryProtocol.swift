//
//  QuoteRepositoryProtocol.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

protocol QuoteRepositoryProtocol {
    func fetchQuote() async throws -> QuoteResponse
}
