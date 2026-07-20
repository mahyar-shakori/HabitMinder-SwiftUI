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
            return LocalizedStrings.Alert.Network.invalidURL
        case .invalidResponse:
            return LocalizedStrings.Alert.Network.decodingFailed
        case .unacceptableStatusCode(let code):
            // Should Change
            return "(BAD RESPONSE CODE: \(code))"
        case .decodingFailed:
            return LocalizedStrings.Alert.Network.invalidMultipartBody
        }
    }
}
