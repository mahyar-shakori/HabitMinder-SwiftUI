//
//  NetworkAPIConfiguration.swift
//  HabitMinder
//
//  Created by Mahyar on 25/06/2025.
//

import Foundation

struct NetworkAPIConfiguration {
    let timeoutInterval: TimeInterval
    static let `default` = NetworkAPIConfiguration(timeoutInterval: 30)
}
