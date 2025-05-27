//
//  QuoteResponse.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/04/2025.
//

import Foundation

struct QuoteResponse: Decodable {
    let quote: String
    let author: String
    let category: String
}
