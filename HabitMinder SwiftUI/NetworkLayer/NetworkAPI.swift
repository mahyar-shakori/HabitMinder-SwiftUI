//
//  NetworkAPI.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

protocol NetworkAPIProtocol {
    func fetchData<T: Decodable>(from endpoint: Endpoint, decodeType: T.Type) async throws -> T
}

final class NetworkAPI: NetworkAPIProtocol {
    
    func fetchData<T: Decodable>(from endpoint: Endpoint, decodeType: T.Type) async throws -> T {
        
        let urlString = endpoint.baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.header?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
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
