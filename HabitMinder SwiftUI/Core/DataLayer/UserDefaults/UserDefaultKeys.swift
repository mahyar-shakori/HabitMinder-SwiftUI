//
//  UserDefaultKeys.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

enum UserDefaultKeys: String, StorageKeyProtocol {
    case userName = "userDefaultsStorage_UserName"
    case isQuoteOff = "userDefaultsStorage_IsQuoteOff"
    case isLogin = "userDefaultsStorage_IsLogin"
}
