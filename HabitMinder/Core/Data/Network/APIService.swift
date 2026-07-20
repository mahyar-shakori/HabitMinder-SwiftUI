//
//  APIService.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

final class APIService: APIFetching {
    private let session: HTTPSession
    private let decoder: JSONDecoder

    init(
        session: HTTPSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
    ) {
        self.session = session
        self.decoder = decoder
    }

    func fetchData<T: Decodable>(from request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.unacceptableStatusCode(httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
