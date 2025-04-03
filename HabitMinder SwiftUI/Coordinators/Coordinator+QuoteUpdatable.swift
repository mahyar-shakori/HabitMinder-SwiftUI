//
//  Coordinator+QuoteUpdatable.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/04/2025.
//

import Foundation

extension Coordinator: QuoteUpdatable {
    func updateQuote(_ quote: String) {
        push(.home(quote: quote))
    }
}
