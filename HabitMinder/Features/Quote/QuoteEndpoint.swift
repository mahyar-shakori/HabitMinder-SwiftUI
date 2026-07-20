//
//  QuoteEndpoint.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum QuoteEndpoint: NetworkEndpoint, Sendable {
    case quote
    
    var baseURL: URL? {
        switch self {
        case .quote:
            return APIHost.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .quote:
            return "/v1/quotes"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .quote:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .quote:
            return ["X-Api-Key": Secrets.apiKey]
        }
    }
}
