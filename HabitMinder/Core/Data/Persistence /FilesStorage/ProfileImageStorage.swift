//
//  ProfileImageStorage.swift
//  HabitMinder
//
//  Created by Mahyar on 21/07/2026.
//

import Foundation

final class ProfileImageStorage: ProfileImageStoring {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func loadProfileImage(named fileName: String) -> Data? {
        guard fileName.isNotEmpty else {
            return nil
        }

        return try? Data(contentsOf: fileURL(for: fileName))
    }

    func saveProfileImage(data: Data, replacing oldFileName: String?) throws -> String {
        try fileManager.createDirectory(
            at: profileImagesDirectory,
            withIntermediateDirectories: true
        )

        let fileName = UUID().uuidString + ".image"
        try data.write(to: fileURL(for: fileName), options: [.atomic])

        if let oldFileName, oldFileName != fileName {
            deleteProfileImage(named: oldFileName)
        }

        return fileName
    }

    func deleteProfileImage(named fileName: String) {
        guard fileName.isNotEmpty else {
            return
        }

        try? fileManager.removeItem(at: fileURL(for: fileName))
    }

    func deleteAllProfileImages() {
        try? fileManager.removeItem(at: profileImagesDirectory)
    }

    private var profileImagesDirectory: URL {
        applicationSupportDirectory
            .appendingPathComponent("ProfileImages", isDirectory: true)
    }

    private var applicationSupportDirectory: URL {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(for fileName: String) -> URL {
        profileImagesDirectory.appendingPathComponent(fileName, isDirectory: false)
    }
}
