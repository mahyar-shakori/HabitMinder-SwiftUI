//
//  HTTPHeaderValue.swift
//  HabitMinder
//
//  Created by Mahyar on 25/06/2025.
//

import Foundation

enum HTTPHeaderValue {
    static let json = "application/json"
    static func multipart(boundary: String) -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
}
