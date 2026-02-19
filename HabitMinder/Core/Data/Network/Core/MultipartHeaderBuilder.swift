//
//  MultipartHeaderBuilder.swift
//  HabitMinder
//
//  Created by Mahyar on 25/06/2025.
//

enum MultipartBoundaryBuilder {
    static func boundary(_ boundary: String) -> String {
        return "\(MultipartConstants.boundaryPrefix)\(boundary)\(MultipartConstants.newLine)"
    }

    static func closing(boundary: String) -> String {
        return "\(MultipartConstants.boundaryPrefix)\(boundary)--\(MultipartConstants.newLine)"
    }
}
