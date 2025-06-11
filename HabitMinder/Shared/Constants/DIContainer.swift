//
//  DIContainer.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 10/06/2025.
//

import Foundation
import SwiftData

struct DIContainer {
    struct Database {
        let habitDataManager: AnyDataManager<HabitModel>
        let futureHabitDataManager: AnyDataManager<FutureHabitModel>
        
        init(context: ModelContext) {
            habitDataManager = AnyDataManager(DataManager<HabitModel>(context: context))
            futureHabitDataManager = AnyDataManager(DataManager<FutureHabitModel>(context: context))
        }
    }
    
    struct UserDefaults {
        static let languageStorage = AnyUserDefaultsStorage(UserDefaultsStorage<UserDefaultKeys, String>(key: .language))
        static let userNameStorage = AnyUserDefaultsStorage(UserDefaultsStorage<UserDefaultKeys, String>(key: .userName))
        static let loginStorage = AnyUserDefaultsStorage(UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin))
        static let colorStorage = AnyUserDefaultsStorage(UserDefaultsStorage<UserDefaultKeys, [CGFloat]>(key: .appPrimaryColor))
    }
}
