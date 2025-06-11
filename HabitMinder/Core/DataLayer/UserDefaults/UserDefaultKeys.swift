//
//  UserDefaultKeys.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum UserDefaultKeys: String, StorageKeyProtocol {
    case language = "userDefaultsStorage_Language"
    case userName = "userDefaultsStorage_UserName"
    case isLogin = "userDefaultsStorage_IsLogin"
    case appPrimaryColor = "userDefaultsStorage_AppPrimaryColor"
}
