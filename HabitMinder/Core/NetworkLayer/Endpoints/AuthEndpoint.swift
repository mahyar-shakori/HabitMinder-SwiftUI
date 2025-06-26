//
//  AuthEndpoint.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum AuthEndpoints: Endpoint {
    case getQuote
    
    struct Body: Encodable {}
    
    var method: HTTPMethod {
        switch self {
        case .getQuote:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getQuote:
            return "/v1/quotes"
        }
    }
    
    var body: Body? {
        switch self {
        case .getQuote:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getQuote:
            return ["X-Api-Key": Secrets.apiKey]
        }
    }
    
    var isMultipart: Bool {
        switch self {
        default:
            return false
        }
    }
    
    var multipartParts: [MultipartPart]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
