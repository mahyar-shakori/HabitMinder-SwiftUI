//
//  String+Formatting.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import Foundation

extension String {
    func quoted() -> String {
        "\"\(self)\""
    }

    func asAuthor() -> String {
        "- \(self)"
    }
}
