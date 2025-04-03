//
//  NetworkAPIError.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum NetworkAPIError: Error {
    case invalidURL
    case decodingError
    case badResponseError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Failed to decode response"
        case .badResponseError:
            return "Invalid response or error from the server."
        }
    }
}
