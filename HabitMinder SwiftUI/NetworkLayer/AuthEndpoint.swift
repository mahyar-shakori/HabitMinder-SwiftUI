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
    
    var body: [String : Any]? {
        [:]
    }
    
    var header: [String : String]? {
        ["X-Api-Key": "WVoh/2pfe2Dk0xLGzNYEDw==ctJva9cIWG3loJCJ"]
    }
    
    var path: String {
        switch self {
        case .getQuote:
            return "/v1/quotes"
        }
    }
}
