//
//  APIFetching.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 27/05/2025.
//

import Foundation

protocol APIFetching: Sendable {
    func fetchData<T: Decodable>(
        from endpoint: URLRequest
    ) async throws -> T
}
