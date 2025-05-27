//
//  Endpoint.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

struct NinjasAPI {
    static let url: String = "api-ninjas.com"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
    var header: [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        "https://api.\(NinjasAPI.url)"
    }
    
    var httpBody: Data? {
        guard let body = body else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
