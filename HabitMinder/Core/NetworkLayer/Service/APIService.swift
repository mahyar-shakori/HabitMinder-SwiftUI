//
//  APIService.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class APIService: APIFetching {
    private let configuration: NetworkAPIConfiguration

    init(configuration: NetworkAPIConfiguration = .default) {
        self.configuration = configuration
    }

    func fetchData<T: Decodable, E: Endpoint>(from endpoint: E) async throws -> T {
        let request = try endpoint.asURLRequest(configuration: configuration)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkAPIError.badResponseError
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkAPIError.decodingError
        }
    }
}
