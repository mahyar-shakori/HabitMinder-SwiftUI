//
//  MultipartPart.swift
//  HabitMinder
//
//  Created by Mahyar on 25/06/2025.
//

import Foundation

struct MultipartPart {
    let name: String
    let data: Data
    let filename: String?
    let mimeType: String?
}
