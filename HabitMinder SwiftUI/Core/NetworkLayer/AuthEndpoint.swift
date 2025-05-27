//
//  AuthEndpoint.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum AuthEndpoint {
    case getQuote
}

extension AuthEndpoint: Endpoint {
    
    var method: HTTPMethod {
        switch self {
        case .getQuote:
            return .get
        }
    }
   
    var body: [String: Any]? {
        switch self {
        case .getQuote:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getQuote:
            return ["X-Api-Key": "WVoh/2pfe2Dk0xLGzNYEDw==ctJva9cIWG3loJCJ"]
        }
    }
    
    var path: String {
        switch self {
        case .getQuote:
            return "/v1/quotes"
        }
    }
}
