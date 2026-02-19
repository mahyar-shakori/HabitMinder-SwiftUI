//
//  APIHost.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

enum APIHost {
    case getQuote
    case addObject
    
    var baseURL: String {
        switch self {
        case .getQuote:
            return "https://api.api-ninjas.com"
        case .addObject:
            return "https://api.restful-api.dev"
        }
    }
}
