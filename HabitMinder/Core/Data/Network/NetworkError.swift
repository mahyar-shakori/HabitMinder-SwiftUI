//
//  NetworkError.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case unacceptableStatusCode(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return L10n.Alert.Network.invalidURL
        case .invalidResponse:
            return L10n.Alert.Network.invalidResponse
        case .unacceptableStatusCode(let code):
            return L10n.Alert.Network.unacceptableStatusCode(code)
        case .decodingFailed:
            return L10n.Alert.Network.decodingFailed
        }
    }
}
