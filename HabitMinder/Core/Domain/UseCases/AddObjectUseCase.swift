//
//  AddObjectUseCase.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

import Foundation

struct AddObjectUseCase {
    private let repository: AddObjectRepositoryProtocol
    
    init(repository: AddObjectRepositoryProtocol = AddObjectRepository()) {
        self.repository = repository
    }
    
    func execute(body: AddObjectBody) async throws -> AddObjectResponse {
        try await repository.addObject(body: body)
    }
}
