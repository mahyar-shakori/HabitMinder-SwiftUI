//
//  HTTPSession.swift
//  HabitMinder
//
//  Created by Mahyar on 19/07/2026.
//

import Foundation

protocol HTTPSession: Sendable {
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {}
