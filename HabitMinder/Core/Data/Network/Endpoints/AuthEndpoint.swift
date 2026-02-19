//
//  AuthEndpoint.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum AuthEndpoints: Endpoint {
    case getQuote
    case addObject(AddObjectBody)
    
    var host: APIHost {
        switch self {
        case .getQuote:
            return .getQuote
        case .addObject:
            return .addObject
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getQuote:
            return .get
        case .addObject:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getQuote:
            return "/v1/quotes"
        case .addObject:
            return "/objects"
        }
    }
    
    var body: Encodable? {
        switch self {
        case .getQuote:
            return nil
        case .addObject(let body):
            return body
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getQuote:
            return ["X-Api-Key": Secrets.apiKey]
        case .addObject:
            return nil
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
