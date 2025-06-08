//
//  NetworkAPI.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class NetworkAPI: DataFetcher {
    private let configuration: NetworkAPIConfiguration

    init(configuration: NetworkAPIConfiguration = .default) {
        self.configuration = configuration
    }

    func fetchData<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let urlString = endpoint.baseURL + endpoint.path

        guard let url = URL(string: urlString) else {
            throw NetworkAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = configuration.timeoutInterval
        
        endpoint.header?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        if endpoint.method != .get {
            request.httpBody = endpoint.httpBody
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkAPIError.badResponseError
        }

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkAPIError.decodingError
        }
    }
}
