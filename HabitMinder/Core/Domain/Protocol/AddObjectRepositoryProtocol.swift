//
//  AddObjectRepositoryProtocol.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

protocol AddObjectRepositoryProtocol {
    func addObject(body: AddObjectBody) async throws -> AddObjectResponse
}
