//
//  ProfileImageUseCasing.swift
//  HabitMinder
//
//  Created by Mahyar on 23/07/2026.
//

import Foundation

protocol ProfileImageUseCasing {
    func loadProfileImage() -> Data?
    func setProfileImage(data: Data) -> Data?
}
