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
            return L10n.Alert.Network.decodingFailed
        case .unacceptableStatusCode(let code):
            // Should Change
            return "(BAD RESPONSE CODE: \(code))"
        case .decodingFailed:
            return L10n.Alert.Network.invalidMultipartBody
        }
    }
}
