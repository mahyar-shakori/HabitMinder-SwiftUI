//
//  AddObjectRepository.swift
//  HabitMinder
//
//  Created by Mahyar on 16/10/2025.
//

import Foundation

final class AddObjectRepository: AddObjectRepositoryProtocol {
    private let apiService: APIFetching
    
    init(apiService: APIFetching = APIService()) {
        self.apiService = apiService
    }
    
    func addObject(body: AddObjectBody) async throws -> AddObjectResponse {
        try await apiService.fetchData(from: AuthEndpoints.addObject(body))
    }
}
