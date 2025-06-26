//
//  NetworkAPIError.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum NetworkAPIError: Error, LocalizedError {
    case invalidURL
    case decodingError
    case badResponseError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return LocalizedStrings.Alert.Network.invalidURL
        case .decodingError:
            return LocalizedStrings.Alert.Network.decodingFailed
        case .badResponseError:
            return LocalizedStrings.Alert.Network.badResponse
        }
    }
}
