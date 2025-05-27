//
//  WelcomeViewCoordinator+QuoteUpdatable.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 03/04/2025.
//

import Foundation

extension WelcomeViewCoordinator: QuoteUpdatable {
    func updateQuote(_ quote: String) {
        goToHome(quote: quote)
    }
}
