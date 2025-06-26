//
//  MultipartBoundaryBuilder.swift
//  HabitMinder
//
//  Created by Mahyar on 25/06/2025.
//

import Foundation

enum MultipartHeaderBuilder {
    static func contentDisposition(name: String, filename: String? = nil) -> String {
        var value = "form-data; name=\"\(name)\""
        if let filename = filename {
            value += "; filename=\"\(filename)\""
        }
        return "\(HTTPHeaderKey.contentDisposition): \(value)"
    }

    static func contentType(_ mimeType: String) -> String {
        return "\(HTTPHeaderKey.contentType): \(mimeType)"
    }
}
