//
//  APIFetching.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 27/05/2025.
//

import Foundation

protocol APIFetching {
    func fetchData<T: Decodable, E: Endpoint>(from endpoint: E) async throws -> T
}
