//
//  DataFetcher.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 27/05/2025.
//

import Foundation

protocol DataFetcher {
    func fetchData<T: Decodable>(from endpoint: Endpoint) async throws -> T
}
