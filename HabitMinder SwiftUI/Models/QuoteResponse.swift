//
//  QuoteResponse.swift
//  HabitMinder 21 Days
//
//  Created by Mahyar on 1/7/24.
//

import Foundation

struct QuoteResponse: Decodable {
    let quote: String
    let author: String
    let category: String
}
