//
//  QuoteRepositoryProtocol.swift
//  HabitMinder
//
//  Created by Mahyar on 19/07/2026.
//

protocol QuoteRepositoryProtocol: Sendable {
    func fetchQuote() async throws -> [Quote]
}
