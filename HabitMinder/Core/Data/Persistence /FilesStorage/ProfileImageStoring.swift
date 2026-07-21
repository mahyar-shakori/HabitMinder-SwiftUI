//
//  ProfileImageStoring.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import Foundation

protocol ProfileImageStoring {
    func loadProfileImage(named fileName: String) -> Data?
    func saveProfileImage(data: Data, replacing oldFileName: String?) throws -> String
    func deleteProfileImage(named fileName: String)
    func deleteAllProfileImages()
}
