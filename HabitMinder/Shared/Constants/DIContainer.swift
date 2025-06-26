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
        let userNameStorage: AnyUserDefaultsStorage<String>
        let loginStorage: AnyUserDefaultsStorage<Bool>
        let colorStorage: AnyUserDefaultsStorage<[CGFloat]>

        init() {
            self.init(
                initialUserName: nil,
                initialLoginValue: nil,
                initialColor: nil
            )
        }

        init(
            initialUserName: String? = nil,
            initialLoginValue: Bool? = false,
            initialColor: [CGFloat]? = nil
        ) {
            let userNameStore = UserDefaultsStorage<UserDefaultKeys, String>(key: .userName)
            if let name = initialUserName { userNameStore.save(value: name) }

            let loginStore = UserDefaultsStorage<UserDefaultKeys, Bool>(key: .isLogin)
            if let login = initialLoginValue { loginStore.save(value: login) }

            let colorStore = UserDefaultsStorage<UserDefaultKeys, [CGFloat]>(key: .appPrimaryColor)
            if let color = initialColor { colorStore.save(value: color) }

            self.userNameStorage = AnyUserDefaultsStorage(userNameStore)
            self.loginStorage = AnyUserDefaultsStorage(loginStore)
            self.colorStorage = AnyUserDefaultsStorage(colorStore)
        }
    }
}
