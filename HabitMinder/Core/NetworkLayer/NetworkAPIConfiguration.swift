//
//  NetworkAPIConfiguration.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/06/2025.
//

import Foundation

struct NetworkAPIConfiguration {
    let timeoutInterval: TimeInterval

    static let `default` = NetworkAPIConfiguration(timeoutInterval: 30)
}
